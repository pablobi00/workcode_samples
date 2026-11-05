#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../edgeops/files/task_helper.rb'

require 'cgi'
require 'json'
require 'puppet_x/puppetlabs/netconf/session'

result = PuppetX::Puppetlabs::Netconf::Session.with_session do |session|
  vlan_id = session.task_params['vlan_id']
  name = session.task_params['name']
  network_instance = session.task_params.fetch('network_instance', 'default')

  unless vlan_id.is_a?(Integer) && vlan_id.between?(1, 4094)
    raise "Parameter 'vlan_id' must be an integer between 1 and 4094"
  end

  unless network_instance.is_a?(String) && !network_instance.empty?
    raise "Parameter 'network_instance' must be a non-empty string"
  end

  if name && !name.is_a?(String)
    raise "Parameter 'name' must be a string"
  end

  escaped_vlan_id = CGI.escapeHTML(vlan_id.to_s)
  escaped_name = name && CGI.escapeHTML(name)
  escaped_network_instance = CGI.escapeHTML(network_instance)

  config = <<~XML
    <config>
      <network-instances xmlns="http://openconfig.net/yang/network-instance">
        <network-instance>
          <name>#{escaped_network_instance}</name>
          <vlans xmlns="http://openconfig.net/yang/vlan">
            <vlan>
              <vlan-id>#{escaped_vlan_id}</vlan-id>
              <config>
                <vlan-id>#{escaped_vlan_id}</vlan-id>
                #{escaped_name ? "<name>#{escaped_name}</name>" : ''}
              </config>
            </vlan>
          </vlans>
        </network-instance>
      </network-instances>
    </config>
  XML

  session.logger.info("Creating VLAN #{vlan_id} in network instance #{network_instance}")
  session.edit_config(config)
  session.commit

  session.report_result({
    'status' => 'success',
    'vlan_id' => vlan_id,
    'name' => name,
    'network_instance' => network_instance,
    'message' => "VLAN #{vlan_id} created successfully"
  })
end

puts result.to_json