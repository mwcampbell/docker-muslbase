FROM mwcampbell/muslbase-build-base
ENV ROOT /newroot
RUN mkdir $ROOT
ADD . $ROOT/src
ENV RUNTIME_ROOT $ROOT/runtime
RUN mkdir $RUNTIME_ROOT
env STATIC_RUNTIME_ROOT $ROOT/static-runtime
RUN mkdir $STATIC_RUNTIME_ROOT
RUN $ROOT/src/build-prerequisites.sh && \
    $ROOT/src/build-temporary.sh
ADD dev.tar $ROOT/dev/
ADD dev.tar $RUNTIME_ROOT/dev
ADD dev.tar $STATIC_RUNTIME_ROOT/dev
RUN chroot $ROOT /src/build-final.sh && \
    rm -rf $ROOT/src && \
    rm -rf $ROOT/tools && \
    (find $ROOT type f -name "*.a" -print | xargs strip --strip-debug) && \
    (find $ROOT type f -name "*.o" -print | xargs strip --strip-debug) && \
    ((find $ROOT -type f -print | grep -v '\.a$' | grep -v '\.o$' | xargs strip --strip-all) || true) && \
    tar cvpf /runtime-rootfs.tar -C $RUNTIME_ROOT . && \
    rm -rf $RUNTIME_ROOT && \
    tar cvpf /static-runtime-rootfs.tar -C $STATIC_RUNTIME_ROOT . && \
    rm -rf $STATIC_RUNTIME_ROOT && \
    tar cvpf /rootfs.tar -C $ROOT .
