Facter.add('hosts_version') do
    setcode do
        ret = 'false'
        if FileTest.exists?('/etc/hosts')
            File.open('/etc/hosts') do |file|
                file.grep(/# managed by Puppet class "hosts" \((.*)\)$/) do |line|
                    ret = $1
                end
            end
        end
        ret
    end
end


