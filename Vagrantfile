# -*- mode: ruby -*-
# vim: set ft=ruby :
MACHINES = {
    :backup => {
        :box_name => "centos/7",
        :ip_addr => '192.168.56.10',
        :disks => {
            :sata1 => {
                :dfile => './sata1.vdi',
                :size => 2048,
                :port => 1
            }
            }
    },
    :client => {
        :box_name => "centos/7",
        :ip_addr => '192.168.56.11',
        :disks => {
            :sata1 => {
                :dfile => './sata2.vdi',
                :size => 2048,
                :port => 2
            }
            }
    },

}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
      config.vm.define boxname do |box|
          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s
          box.vm.network "private_network", ip: boxconfig[:ip_addr]
          box.vm.provider :virtualbox do |vb|
            	  vb.customize ["modifyvm", :id, "--memory", "1024"]
                  needsController = false
		  boxconfig[:disks].each do |dname, dconf|
			  unless File.exist?(dconf[:dfile])
				vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
                                needsController =  true
                          end
		  end
                  if needsController == true
                     vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
                     boxconfig[:disks].each do |dname, dconf|
                         vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                     end
                  end

          end
      end
      case boxname.to_s
          when "client"
             config.vm.provision "ansible" do |ansible|
               ansible.playbook = "client.yml"
               ansible.become = "true"
             end
          when "backup"
               config.vm.provision "ansible" do |ansible|
               ansible.playbook = "backup.yml"
               ansible.become = "true"
             end
       end

  end
end
