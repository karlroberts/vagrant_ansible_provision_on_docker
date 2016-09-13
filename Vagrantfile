# This guide is optimized for Vagrant 1.7 and above.
# Although versions 1.6.x should behave very similarly, it is recommended
# to upgrade instead of disabling the requirement below.
Vagrant.require_version ">= 1.7.0"

Vagrant.configure(2) do |config|

  # Disable the new default behavior introduced in Vagrant 1.7, to
  # ensure that all Vagrant machines will use the same SSH key pair.
  # See https://github.com/mitchellh/vagrant/issues/5005
  config.ssh.insert_key = false

  # always put my gitconfig in place
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "provisioning/playbook.yml"
    ansible.groups = {
      "tag_Name_MyMagicTag_MyAppServer" => ["default"],
      "all_groups:children" => ["tag_Name_MyMagicTag_MyAppServer"],
      "tag_Name_MyMagicTag_MyAppServer:vars" => {"variable1" => 9,
                        "variable2" => "example"}
    }
  end



  # docker - initially build from a Dockerfile then when happy cut an image
  config.vm.hostname = "docker-host-tmp"
  config.vm.provider "docker" do |d, override|
    # Uncomment below to use th image rather than build  from Dockerfile
    #d.image = "foo/myimage"

    # Comment build_dir to use Image rather than build from Dockerfile
    d.build_dir = "."

    # Uncomment elow to specify a particular Dockerfile default is DockerFile in build_dir
    #d.dockerfile = "Dockerfile"

    #
    #
    # SET YOUR GRAPHLAB email and graphlabkey BELOW and tag the container image
    d.build_args = ["--tag=khack1"]

    # vagrant can auto map the ssh ports
    d.has_ssh = true
    d.name = "karlhackingenv1"
    d.create_args  = ["-w", "/home/vagrant"]

    # map the host:container ports. ipython notebook uses 8888
    d.ports = ["8888:8888"]
  end

  config.vm.provider "virtualbox" do |v, override|
    override.vm.box = "ubuntu/trusty64"
  end

  config.vm.provider "vmware_fusion"

  #port forwards
  # If you run Docker in a Virtual Machin Box rather than nativly in Host systems Docker
  # you may need to expose the VM ports to your host if you want to connect to the ipython notebook
  # in this example you would then go to http://localhost:8887 on your Host OS
  ## ipython notebook
  # config.vm.network "forwarded_port", guest: 8888, host: 8887, protocol: "tcp"


end
