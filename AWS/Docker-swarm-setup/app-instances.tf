resource "aws_instance" "master" {
  ami  = "ami-0a19090b0c4402eee"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.swarm.name}"]
  key_name = "swarm"
}

resource "null_resource" "copy_execute" {

   connection {
     type = "ssh"
     host = aws_instance.master.public_ip
     user = "ubuntu"
     private_key = file("swarm.pem")
   }
    provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
	  "sudo wget https://download.docker.com/linux/ubuntu/gpg && sudo apt-key add gpg",
	  "sudo sh -c 'echo \"deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable\" >> /etc/apt/sources.list'",
      "sudo apt-get -y update",
      "sudo apt install -y docker-ce",
      "sudo docker swarm init",
      "sudo docker swarm join-token --quiet worker > /home/ubuntu/token"
    ]
  }
}

resource "aws_instance" "slave" {
  //count         = 2
  ami           = "ami-0a19090b0c4402eee"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.swarm.name}"]
  key_name = "swarm"
 
  connection {
     type = "ssh"
     host = aws_instance.slave.public_ip
     user = "ubuntu"
     private_key = file("swarm.pem")
   }

  provisioner "file" {
    source = "swarm.pem"
    destination = "/home/ubuntu/swarm.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
	  "sudo wget https://download.docker.com/linux/ubuntu/gpg && sudo apt-key add gpg",
	  "sudo sh -c 'echo \"deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable\" >> /etc/apt/sources.list'",
      "sudo apt-get -y update",
      "sudo apt install -y docker-ce",
      "sudo chmod 400 /home/ubuntu/swarm.pem",
      "sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i swarm.pem ubuntu@${aws_instance.master.private_ip}:/home/ubuntu/token .",
      "sudo docker swarm join --token $(cat /home/ubuntu/token) ${aws_instance.master.private_ip}:2377"
    ]
  }
  
}
