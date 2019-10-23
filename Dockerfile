FROM conoria/alpine-r-bookdown

WORKDIR /usr/src

COPY . .

RUN Rscript -e 'devtools::install_deps()'

