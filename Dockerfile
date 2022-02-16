FROM ocaml/opam:debian-10-ocaml-4.12

RUN mkdir tutorial
WORKDIR tutorial/
COPY . .

RUN sudo rm -rf _build

# Python stuff
 
RUN sudo apt-get -y update
RUN sudo apt-get install -y build-essential python3.6 python3-pip python3-dev
RUN sudo pip3 -q install pip --upgrade
RUN sudo pip3 install jupyter
 
# OCaml stuff

RUN sudo apt-get -y install wget unzip pkg-config gfortran \
    libplplot-dev libopenblas-dev liblapacke-dev gnuplot \
    libgmp-dev libzmq3-dev

RUN opam install -y dune base owl jupyter fpath merlin \
    ocamlformat ppx_inline_test ppx_accessor accessor accessor_base 

RUN eval $(opam env)  
ENV PATH=$HOME/.opam/4.12/bin:$PATH

RUN ocaml-jupyter-opam-genspec 
RUN sudo jupyter kernelspec install --name ocaml-jupyter $HOME/.opam/4.12/share/jupyter

RUN git clone https://github.com/tachukao/dilqr.git $HOME/dilqr && \
    git clone https://github.com/tachukao/owl_bmo.git $HOME/owl_bmo && \
    git clone https://github.com/hennequin-lab/comm.git $HOME/comm && \
    git clone https://github.com/hennequin-lab/owl_parameters.git $HOME/owl_parameters && \
    git clone https://github.com/hennequin-lab/adam.git $HOME/adam && \
    git clone https://github.com/hennequin-lab/gp.git $HOME/gp && \
    git clone https://github.com/hennequin-lab/juplot.git $HOME/juplot && \
    git clone https://github.com/marineschimel/ilqr_vae.git $HOME/ilqr_vae && \
    git clone https://github.com/hennequin-lab/cmdargs.git $HOME/cmdargs 

WORKDIR $HOME/comm
RUN git checkout no-mpi && dune build @install && dune install

WORKDIR $HOME/adam
RUN dune build @install && dune install

WORKDIR $HOME/owl_bmo
RUN dune build @install && dune install

WORKDIR $HOME/cmdargs
RUN dune build @install && dune install

WORKDIR $HOME/dilqr
RUN git checkout tutorial && dune build @install && dune install

WORKDIR $HOME/gp
RUN dune build @install && dune install

WORKDIR $HOME/juplot
RUN dune build @install && dune install

WORKDIR $HOME/owl_parameters
RUN dune build @install && dune install

WORKDIR $HOME/ilqr_vae
RUN git checkout tutorial && dune build @install && dune install

WORKDIR $HOME/tutorial
RUN mkdir -p $HOME/.jupyter/nbconfig
RUN cp notebook.json $HOME/.jupyter/nbconfig

ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN sudo chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

RUN sudo chown -R opam .
RUN sudo chgrp -R opam .
RUN rm -f .git/config && mv config_docker .git/config

CMD ["bash"]
