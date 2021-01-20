# copyright: 2018, Adeel Ahmad

content = inspec.profile.file('terraform.json')
params = JSON.parse(content)

RESOURCE_GROUP = params['resource_group']['value']
DISK_NAME = params['disk_name']['value']

title "Terraform Module Integration Test"

# you add controls here
control "azure-virtual-machines-exist-check" do                                # A unique ID for this control.
  impact 1.0                                                                   # The criticality, if this control fails.
  title "Check if example disk has been created"                       # A human-readable title
    describe azurerm_virtual_machine_disk(resource_group: RESOURCE_GROUP, name: DISK_NAME) do
      it { should exist } # The test itself.
    end
end
