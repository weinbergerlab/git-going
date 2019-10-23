FROM conoria/alpine-r-bookdown

WORKDIR /usr/src

COPY . .

RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com"))' >.Rprofile
RUN Rscript -e 'install.packages("devtools")'
RUN Rscript -e 'devtools::install_deps()'

