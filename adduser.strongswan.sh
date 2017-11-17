#!/bin/sh
#你应该修改一下下面的这个网址
SERVER="my.vpnexample.org"
VPN_PASSWORD="$(LC_CTYPE=C tr -dc 'A-HJ-NPR-Za-km-z2-9' < /dev/urandom | head -c 12)"
#VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASSWORD")
UUID1=$(/usr/bin/uuidgen -r)
UUID2=$(/usr/bin/uuidgen -r)
UUID3=$(/usr/bin/uuidgen -r)
sed -i.bak /$1/d /usr/local/etc/ipsec.secrets
echo "Password for user is: $VPN_PASSWORD"
echo "${1}  %any : EAP \"${VPN_PASSWORD}\"" >> /usr/local/etc/ipsec.secrets
#你可以打开这个注释，主要目的是你在添加新的用户时，脚本可以自动帮你同步到别的地方。免得你调整的时候造成数据丢失
#echo y| cp /usr/local/etc/ipsec.secrets /srv/docker/resiliosync/folders/folders/ikev2/
ipsec rereadsecrets
#以下是 iOS 和 Mac VPN 的自动配置脚本，是实现按需要自动连接
#主注意修改下面的路径为你自己想保存的位置
cat > /srv/docker/resiliosync/folders/folders/ikev2/${1}.mobileconfig <<_EOF_
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PayloadContent</key>
	<array>
		<dict>
			<key>IKEv2</key>
			<dict>
				<key>AuthName</key>
				<string>${1}</string>
				<key>AuthPassword</key>
				<string>${VPN_PASSWORD}</string>
				<key>AuthenticationMethod</key>
				<string>None</string>
				<key>ChildSecurityAssociationParameters</key>
				<dict>
					<key>DiffieHellmanGroup</key>
					<integer>2</integer>
					<key>EncryptionAlgorithm</key>
					<string>AES-256</string>
					<key>IntegrityAlgorithm</key>
					<string>SHA1-96</string>
					<key>LifeTimeInMinutes</key>
					<integer>1440</integer>
				</dict>
				<key>DeadPeerDetectionRate</key>
				<string>Medium</string>
				<key>DisableMOBIKE</key>
				<integer>0</integer>
				<key>DisableRedirect</key>
				<integer>0</integer>
				<key>EnableCertificateRevocationCheck</key>
				<integer>0</integer>
				<key>EnablePFS</key>
				<integer>0</integer>
				<key>ExtendedAuthEnabled</key>
				<true/>
				<key>IKESecurityAssociationParameters</key>
				<dict>
					<key>DiffieHellmanGroup</key>
					<integer>2</integer>
					<key>EncryptionAlgorithm</key>
					<string>AES-128</string>
					<key>IntegrityAlgorithm</key>
					<string>SHA1-96</string>
					<key>LifeTimeInMinutes</key>
					<integer>1440</integer>
				</dict>
				<key>RemoteAddress</key>
				<string>${SERVER}</string>
				<key>RemoteIdentifier</key>
				<string>${SERVER}</string>
				<key>UseConfigurationAttributeInternalIPSubnet</key>
				<integer>0</integer>
			</dict>
			<key>IPv4</key>
			<dict>
				<key>OverridePrimary</key>
				<integer>0</integer>
			</dict>
			<key>OnDemandEnabled</key>
			<integer>1</integer>
			<key>OnDemandRules</key>
			<array>
				<dict>
					<key>Action</key>
					<string>EvaluateConnection</string>
					<key>ActionParameters</key>
					<array>
						<dict>
							<key>DomainAction</key>
							<string>ConnectIfNeeded</string>
							<key>Domains</key>
							<array>
								<string>youtube.com</string>
								<string>youtu.be</string>
								<string>twitter.com</string>
								<string>t.co</string>
								<string>google.com</string>
								<string>goo.gl</string>
								<string>google.cn</string>
								<string>instagram.com</string>
								<string>facebook.com</string>
								<string>fb.me</string>
								<string>tumblr.com</string>
								<string>t66y.com</string>
							</array>
						</dict>
					</array>
				</dict>
				<dict>
					<key>Action</key>
					<string>Disconnect</string>
					<key>InterfaceTypeMatch</key>
					<string>Cellular</string>
				</dict>
				<dict>
					<key>Action</key>
					<string>Disconnect</string>
				</dict>
			</array>
			<key>PayloadDescription</key>
			<string>自动配置黑帮 VPN 设置，Mac与 iOS 通用</string>
			<key>PayloadDisplayName</key>
			<string>IKEv2VPN</string>
			<key>PayloadIdentifier</key>
			<string>com.apple.vpn.managed.08684E7B-E6F3-46E9-8636-359789D1E227</string>
			<key>PayloadType</key>
			<string>com.apple.vpn.managed</string>
			<key>PayloadUUID</key>
			<string>${UUID1}</string>
			<key>PayloadVersion</key>
			<integer>1</integer>
			<key>Proxies</key>
			<dict>
				<key>HTTPEnable</key>
				<integer>0</integer>
				<key>HTTPSEnable</key>
				<integer>0</integer>
			</dict>
			<key>UserDefinedName</key>
			<string>${1} 的 VPN</string>
			<key>VPNType</key>
			<string>IKEv2</string>
		</dict>
	</array>
	<key>PayloadDisplayName</key>
	<string>${1} 的 VPN</string>
	<key>PayloadIdentifier</key>
	<string>heibang.${UUID3}</string>
	<key>PayloadRemovalDisallowed</key>
	<false/>
	<key>PayloadType</key>
	<string>Configuration</string>
	<key>PayloadUUID</key>
	<string>${UUID2}</string>
	<key>PayloadVersion</key>
	<integer>1</integer>
</dict>
</plist>
_EOF_
