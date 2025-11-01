url --url="https://repo.almalinux.org/almalinux/10/BaseOS/x86_64/kickstart/"

text

firstboot --disable
keyboard --vckeymap=fr --xlayouts='fr'
lang fr_FR.UTF-8

network --onboot=yes --device=link --bootproto=static --ip=10.17.112.254 --netmask=255.255.255.0 --gateway=10.17.112.1 --nameserver=1.1.1.1

repo --name="baseos" --mirrorlist="https://mirrors.almalinux.org/mirrorlist/10/baseos"
repo --name="appstream" --mirrorlist="https://mirrors.almalinux.org/mirrorlist/10/appstream"
repo --name="CRB" --mirrorlist="https://mirrors.almalinux.org/mirrorlist/10/crb/"
repo --name="epel-release" --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=epel-10&arch=x86_64"

user --groups=wheel --name="autoinst" --iscrypted --password='$6$Yz9aoMYXePJ7PE3B$vXza2qVDVab4ZTVZ2Bk/vWD8wJNOdQs0Doeoy7iezdeSZfpRVOfqDPCTmF6uo/SNVThhy/UG3s10AxMT2weOr.' --uid=1000 --gecos="Automation User" --gid=1000

timezone "Europe/Paris" --utc

bootloader --location=mbr --append=" net.ifnames=0 biosdevname=0 crashkernel=no"
zerombr
clearpart --all --initlabel
autopart --type=lvm

reboot

%packages --excludedocs
sudo
openssh-server
qemu-guest-agent
cloud-init
%end

%addon com_redhat_kdump --disable
%end

%post

cat <<EOF >> /etc/sudoers
Defaults !requiretty
root ALL=(ALL) ALL
autoinst ALL=(ALL) NOPASSWD: ALL
EOF

/usr/bin/systemctl enable sshd
/usr/bin/systemctl start sshd

/usr/bin/yum -y update
/usr/bin/yum clean all
%end
