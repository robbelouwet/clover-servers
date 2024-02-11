#!/bin/bash

az containerapp revision deactivate --resource-group rg-robbelouwet-02 \
                                    --subscription 024b490b-4f80-43a1-9d24-808740052ded \
                                    --revision paper-auto-server--j1zuqix

az containerapp revision deactivate --resource-group rg-robbelouwet-02 \
                                    --subscription 024b490b-4f80-43a1-9d24-808740052ded \
                                    --revision paper-auto-velocity--zd07884
