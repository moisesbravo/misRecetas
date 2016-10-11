#actualizar librerias
#apt-get -y update
execute "update-upgrade" do
  command "apt-get update  -y"
  action :run
end

# Istalar el cliente mysql 
mysql_client 'default' do
  action :create
  package_version ''
end

#crea BD
#Crea Usuarios 

## modifica y mueve template a tmp/deploy/db
directory '/var/tmp/deploy/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/var/tmp/deploy/bd' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/var/tmp/deploy/bd/bd.sql' do
  source 'database.erb'
  mode '0644'
  variables({
     :url => node['deploy']['url'],
     :xx => node['deploy']['url']
  })
  

end


# Ejecuta Script de BD
execute 'restore-databases' do
  command "mysql -h #{node['deploy']['host']} -u #{node['deploy']['username']} -p#{node['deploy']['host']} -D prueba < /var/tmp/deploy/bd/bd.sql"
end

#elimina carpeta /var/tmp/deploy/db