import asyncio
import os
import pathlib
import ssl
import websockets
from aioconsole import aprint
import sys

connection_task: asyncio.Task = None


class SubprocessHandler:
    def __init__(self, subprocess: asyncio.subprocess.Process):
        self.process = subprocess
        self.output_buffer: list = []
        self.socket_tuple: [websockets.WebSocketServerProtocol, bool] = None

    async def buffer_process_stdout(self):
        while True:
            line = await self.process.stdout.readline()

            if not line:
                await aprint("no line in STDOUT, breaking")
                break

            decoded_line = line.decode('utf-8')

            # Append to history
            await aprint(decoded_line, end='')
            self.output_buffer.append(decoded_line)

            # Don't do anything if there's no socket connected
            if not self.socket_tuple or self.socket_tuple[0].closed:
                continue

            # Send line
            await self.socket_tuple[0].send(decoded_line)

    async def write_line(self):
        await aprint(f"New socket_to_stdin coroutine with socket {self.socket_tuple[0].__hash__()}")

        while True:
            try:
                user_input = await asyncio.wait_for(self.socket_tuple[0].recv(), timeout=1)

            # Timeout's just re-iterate the loop
            except asyncio.TimeoutError as e:
                continue

            # If the connection got closed, end the coroutine.
            # This is why we timeout the recv() coroutine in order to catch this before new connections occur
            except (websockets.ConnectionClosedOK, websockets.ConnectionClosed, websockets.ConnectionClosedError) as e:
                await aprint(f"Connection (forcibly) closed!: {e}")
                break

            # If the user input timed out, just re-iterate
            if user_input is None:
                continue

            await aprint(f"> {user_input}\nsocket: {self.socket_tuple[0].__hash__()}")
            await self.socket_tuple[0].send(f"> {user_input}")
            self.process.stdin.write(bytes(user_input + '\n', 'UTF-8'))
            await self.process.stdin.drain()

    async def write_history(self):
        for history_line in self.output_buffer:
            await self.socket_tuple[0].send(history_line)
        await self.socket_tuple[0].send("---- CONSOLE HISTORY RESTORED ----")


async def connect(websocket: websockets.WebSocketServerProtocol, path, process_handler):
    await aprint("New connection!")

    global connection_task

    # If a new connection is initiated, kill the previous one and reset it to this one as a singleton
    if process_handler.socket_tuple and process_handler.socket_tuple[0] is not None:
        await process_handler.socket_tuple[0].close()
    process_handler.socket_tuple = [websocket, False]

    # First, write the console history
    await process_handler.write_history()

    # Start listening to ws channel for input concurrently
    await aprint(f"Scheduling tasks with websocket {websocket.__hash__()}")
    connection_task = asyncio.create_task(process_handler.write_line())

    # Wait for the subprocess to finish
    await process_handler.process.wait()

    await aprint("Process exited!")

    # Cancel the tasks to exit the event loop
    connection_task.cancel()

    await websocket.send("Server exited.")
    await websocket.close()


async def start_subprocess(command):
    return await asyncio.create_subprocess_shell(
        command,
        stdin=asyncio.subprocess.PIPE,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )


# entry point
async def main():
    # Start and run the subprocess independently of the websocket server lifecycle on the event loop
    command = ' '.join(sys.argv[1:])
    await aprint(f"Running subprocess: {command}")
    subprocess_handler = SubprocessHandler(await start_subprocess(command))

    # Run the tasks concurrently using asyncio.gather()
    ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ssl_context.load_cert_chain("/certificate.pem", "/certificate.key")
    task1 = subprocess_handler.buffer_process_stdout()
    task2 = websockets.serve(lambda ws, path: connect(ws, path, subprocess_handler), "0.0.0.0", 8765, ssl=ssl_context)

    await asyncio.gather(task1, task2)


if __name__ == "__main__":
    asyncio.run(main())
