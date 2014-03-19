FROM mwcampbell/muslbase-build-base
RUN mkdir /newroot
ENV ROOT /newroot
ADD . /newroot/src
RUN $ROOT/src/build-prerequisites.sh && \
    $ROOT/src/build-temporary.sh
ADD dev.tar $ROOT/dev/
RUN chroot $ROOT /src/build-final.sh && \
    rm -rf $ROOT/src && \
    rm -rf $ROOT/tools && \
    (find $ROOT type f -name "*.a" -print | xargs strip --strip-debug) && \
    (find $ROOT type f -name "*.o" -print | xargs strip --strip-debug) && \
    ((find $ROOT -type f -print | grep -v '\.a$' | grep -v '\.o$' | xargs strip --strip-all) || true) && \
    tar cvpf /rootfs.tar -C $ROOT .
