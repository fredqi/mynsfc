FROM fredqi/texlive:minimal

COPY .docker/packages.txt /tmp/

WORKDIR /tmp/

RUN TLMGR=$(find /usr/local/texlive -name tlmgr) && \
    ${TLMGR} install $(cat packages.txt) && \
    ${TLMGR} path add && \
    luaotfload-tool -v -u
    
