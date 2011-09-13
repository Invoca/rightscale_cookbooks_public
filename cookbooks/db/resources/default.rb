# Cookbook Name:: db
#
# Copyright (c) 2011 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Add actions to @action_list array.
# Used to allow comments between entries.
def self.add_action(sym)
  @action_list ||= Array.new
  @action_list << sym unless @action_list.include?(sym)
  @action_list
end

# = Database Attributes
#
# Below are the attributes defined by the db resource interface.
#

# == General options
attribute :user, :kind_of => String, :default => "root"
attribute :password, :kind_of => String, :default => ""
attribute :data_dir, :kind_of => String, :default => "/mnt/storage"

# == Backup/Restore options
attribute :lineage, :kind_of => String
attribute :force, :kind_of => String, :default => "false"
attribute :timestamp_override, :kind_of => String, :default => nil
attribute :from_master, :kind_of => String, :default => nil

# == Privilege options
attribute :privilege, :equal_to => [ "administrator", "user" ], :default => "administrator"
attribute :privilege_username, :kind_of => String
attribute :privilege_password, :kind_of => String
attribute :privilege_database, :kind_of => String, :default => "*.*" # All databases


# = General Database Actions
#
# Below are the actions defined by by the db resource interface.
#

# == Stop
# Stop the database service.
#
# Calls the correct init.d script for the database and platform.
#
add_action :stop                  

# == Start
# Start the database service.
#
# Calls the correct init.d script for the database and platform.
#
add_action :start                 

# == Status
# Log the status of the database service.
#
# Calls the correct init.d script for the database and platform
# and send the output to the Chef log and RightScale audit entries. 
#
add_action :status                

# == Lock
# Lock the database so writes will be blocked.
#
# This must insure a conistent state while taking a snapshot.
#
add_action :lock       

# == Unlock
# Unlock the database so writes can occur.
#
# This must be called as soon as possible after calling the :lock action
# since no clients will be blocked from writting.
#
add_action :unlock

# == Reset
# Wipes the current database into a pristine state.
#  
# This utility action can be useful in development and test environments.  
# Not recommended for production use.  
# 
# WARNING: this will delete any data in your database!
#
add_action :reset

         
# == Move Data Directory
# Relocate the database data directory
#
# Moves the data directory from the default install path to the path specified 
# in name attribute or data_dir attribute of the resource.  This is used for 
# relocating the data directory to a block device that provides snapshot 
# functionality.
#
# This action should also setup a symlink from the old path to the new 
# location.
#
add_action :move_data_dir      

# == Pre-backup Check
# Verify the database is in a good state for taking a snapshot.
#
# This action is used to verify correct state and to preform any
# other steps necessary before the database is locked.
#
# This action should raise an exception if the database is not
# in a valid state for a backup.
#
add_action :pre_backup_check 

# == Post-backup Cleanup
# Used to cleanup VM after backup.
#
# This action is called after the backup has completed.  Can be used to cleanup
# any temporary files created from the :pre_backup_check action. 
#
add_action :post_backup_cleanup

# == Write Backup Info
# TODO
add_action :write_backup_info
 
# == Pre-restore Check
# Verify the database is in a good state before preforming a restore.
#
# This action is called before a restore is performed. It should be used to 
# verify that the system is in a correct state for restoring and should 
# preform any other steps necessary before a new block_device is attached
# and the database is stopped for a restore.
#
# This action should raise an exception if the database is not
# in a valid state for a restore.
#        
add_action :pre_restore_check

# == Post-restore Cleanup
# Used to cleanup VM after restore.
#
# This action is called after the block_device restore has completed and  
# before the database is started.
#  
# Used to link the database to the files in the newly restored data_dir.
# Can also be used to perform other steps necessary to cleanup after a 
# restore.
#  
add_action :post_restore_cleanup

# == Set Privileges
# Set database user privileges.
#
# Use the privilage attributes of this resource to setup 'administrator' or 
# 'user' privilages to the given username with the given password.
# 
add_action :set_privileges

# == Install Client
# Installs database client
#
# Use to install the client on any system that needs to connect to the server.
# Also should install language binding packages For example, ruby client gem
# java client jar, php client modules, etc
# 
add_action :install_client

# == Install Server
# Installs database server 
#
add_action :install_server

# == Setup Monitoring
# Install and configure collectd plgins for the server.
#
# This is used by the RightScale platorm to display metrics about the database
# on the RightScale dashboard.  Also enables alerts and escalations for the
# database.
#
add_action :setup_monitoring


actions @action_list

