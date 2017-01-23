FROM rinnocente/qe-full-6.0
#
RUN apt update \
    && apt -yq install gnuplot gnuplot-doc
#
WORKDIR /home/qe
#
RUN wget http://www.qe-forge.org/gf/download/frsrelease/225/1045/thermo_pw.0.6.0.tgz \
    && tar xzf thermo_pw.0.6.0.tgz -C qe-6.0/ \
    && rm thermo_pw.0.6.0.tgz
#
RUN sed -i 's#^all: thermo_pw.*#all: thermo_pw#' qe-6.0/thermo_pw/Makefile
#
WORKDIR /home/qe/qe-6.0/thermo_pw
#
RUN make join_qe \
    && cd .. \
    && make thermo_pw \
    && chown -R qe:qe thermo_pw
EXPOSE 22
RUN service ssh restart
CMD [ "/usr/sbin/sshd","-D" ]
#
