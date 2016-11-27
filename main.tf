resource "digitalocean_droplet" "ciwise-4" {
    image = "debian-8-x64"
    name = "ciwise-4"
    region = "nyc2"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
}

resource "digitalocean_domain" "dns-sandbox" {
  name = "sandbox.ciwise.com"
  ip_address = "${digitalocean_droplet.ciwise-4.ipv4_address}"
}

resource "digitalocean_droplet" "ciwise-3" {
    image = "debian-8-x64"
    name = "ciwise-3"
    region = "nyc2"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    provisioner "file" "ansible-load" {
       connection {
          type = "ssh"
	  user = "root"
	  private_key = "~/.ssh/id_rsa"
       }
      source="script.sh"
      destination = "/tmp/script.sh"
    }

    provisioner "file" "ansible-playbook" {
       connection {
          type = "ssh"
	  user = "root"
	  private_key = "~/.ssh/id_rsa"
       }
      source="playbook.yml"
      destination = "/root/playbook.yml"
    }

    provisioner "remote-exec" {
      connection {
         type = "ssh"
	  user = "root"
          private_key = "~/.ssh/id_rsa"
       }
       inline = [
         "chmod 777 /tmp/script.sh",
	 "/tmp/script.sh"
       ]
    }

}

resource "digitalocean_domain" "dns-ansible" {
  name = "ansible.ciwise.com"
  ip_address = "${digitalocean_droplet.ciwise-3.ipv4_address}"
}


output "ip_ciwise_3" {
  value = ["${digitalocean_droplet.ciwise-3.ipv4_address}"]
}

output "ip_ciwise_4" {
  value = ["${digitalocean_droplet.ciwise-4.ipv4_address}"]
}
