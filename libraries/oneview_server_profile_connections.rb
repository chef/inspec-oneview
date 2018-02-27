# frozen_string_literal: true
require 'oneview_backend'

class OneviewServerProfileConnections < OneviewResourceBase
  name 'oneview_server_profile_connections'

  desc 'InSpec resource to test the connections that have been assigned to a server profile'

  attr_accessor :probes

  # Define the filter table for the resource
  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:exists?) { |x| !x.entries.empty? }
        .add('id')
        .add('name')
        .add('function_type')
        .add('deployment_status')
        .add('network_uri')
        .add('port_id')
        .add('requested_vfs')
        .add('allocated_vfs')
        .add('interconnect_uri')
        .add('mac_type')
        .add('wwpn_type')
        .add('mac')
        .add('wwnn')
        .add('wwpn')
        .add('requested_mbps')
        .add('allocated_mbps')
        .add('maximum_mbps')

  filter.connect(self, :connection_details) 
  
  # Constructor for the resource. This calls the parent constructor
  # to get the generic resource for the all the servers in OneView.
  #
  def initialize(opts = {})
    # The generic resource needs to know what is being sought, for example 'server-hardware'
    opts[:type] = 'server-profiles'
    super(opts)

    # abort if a name has not been specified
    abort 'Resource name must be specified when using the server_profile_connections InSPec resource' if opts[:name].nil?

    # find the servers
    resources
  end

  # Return information about the disks and add to the filter table so that
  # assertions can be performed
  def connection_details
    # Iterate around the connections of the profiler
    connections.each_with_index.map do |connection, index|
      parse_connection(connection, index)
    end
  end

  def parse_connection(resource, index)
    # Create a hash to hold the parsed data
    parsed = {
      number: index + 1 
    }

    # iterate around the keys and values of the resource to build up the 
    # parsed data
    resource.item.each do |key, value|
      parsed[snake_case(key)] = value
    end

    # return the pased hash to the calling function
    parsed
  end
  
end
