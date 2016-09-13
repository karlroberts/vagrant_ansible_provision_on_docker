#
# Karls dev env testing playbooks in
#
# /vagrant
#
# The 'vagrant' user is already setup and his hime dir is /home/vagrant
# his ssh keys are in place so you should not need a password but if you do it
# is 'vagrant'
#
# The 'root' user on the box also has the password 'vagrant'
#
#
#
# This Docker build is designed to be used with vagrant as an interactive shell
# environmnet. So you simply do :-
#
#    vagrant up                         # launch the box
#    vagrant ssh                        # ssh onto the box
#    source /graphlab-env/bin/activate  #change PATH so we use the  graphlab virtual-env
#    jupyter notebook                   # kick of the notebook
#
# If you'd rather use the Docker as simply a jupyter notebook server that
# just starts notebook, then look at the bottom of the file for the comment and
# uncomment notes.
#
#
FROM ubuntu:trusty-20160302

# Get rid of bourne shell issues
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# mandiatry build-args

# Add OS level packages and libraries
#
# basic normal utils like curl git gzip and ssh
#
RUN apt-get update -y && apt-get -y install \
  gzip zip unzip \
  git \
  openssh-server \
  vim \
  curl wget

# set up ssh server run space
RUN mkdir -p /var/run/sshd
RUN chmod 700 /var/run/sshd

# Add vagrant user and passwd and insecure vagrant key
# change root passwd to vagrant
RUN ["/bin/bash", "-c" ,"echo -e \"vagrant\\nvagrant\" | passwd"]
# create vagrant user and add ssh keys
RUN useradd -m -s /bin/bash vagrant
# set vagrant passwd to vagrant
RUN ["/bin/bash", "-c" ,"echo -e \"vagrant\\nvagrant\" | passwd vagrant"]
# add vagrant insecure key so you can simple log into the box with 'vagrant ssh'
RUN mkdir -p /home/vagrant/.ssh
RUN chmod 700  /home/vagrant/.ssh
ADD shells/vagrant.pub  /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
# all vagrant use to sudo to root
RUN echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# add the docker config in case we want to add docker on the docker :-/
ADD shells/etc_default_docker.txt /etc/default/docker


# let Docker know we will expose the ipthon port
EXPOSE 8888


# If I wanted to run the notebook as a server from a container uncomment next 2 lines and romove the lines after these two
RUN mkdir -p /usr/local/bin
RUN echo -e "#!/bin/bash \n\
service ssh restart\n\
echo "kickass ansible provisioned dev env" \n\
top -b " \
>> /usr/local/bin/launch
RUN chmod a+x /usr/local/bin/launch

ENTRYPOINT ["/usr/local/bin/launch"]
