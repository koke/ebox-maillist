# Copyright (C) 
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# Class: EBox::Maillist 
#
#   TODO: Documentation

package EBox::Maillist;

use strict;
use warnings;

use base qw(EBox::GConfModule EBox::Model::ModelProvider
            EBox::Model::CompositeProvider 
            EBox::ServiceModule::ServiceInterface);


use EBox::Validate qw( :all );
use EBox::Global;
use EBox::Gettext;
use EBox::Sudo;

use EBox::Exceptions::InvalidData;
use EBox::Exceptions::MissingArgument;
use EBox::Exceptions::DataExists;
use EBox::Exceptions::DataMissing;
use EBox::Exceptions::DataNotFound;

# Method: _create
#
# Overrides:
#
#       <Ebox::Module::_create>
#
sub _create
{
    my $class = shift;
    my $self = $class->SUPER::_create(name => 'maillist',
            printableName => __('Maillist'),
            domain => 'ebox-maillist',
            @_);
    bless($self, $class);
    return $self;
}

## api functions

# Overrides:
#
#       <EBox::Model::ModelProvider::modelClasses>
sub modelClasses 
{
    return [
        'EBox::Maillist::Model::Settings',
    ];
}

# Overrides:
#
#       <EBox::Model::ModelProvider::compositeClasses>
sub compositeClassess 
{
    return [
        'EBox::Maillist::Composite::Composite',
    ];
}

sub domain
{
    return 'ebox-maillist';
}

# Method: actions
#
#   Override EBox::ServiceModule::ServiceInterface::actions
#
sub actions
{
    return [];
}


# Method: usedFiles
#
#   Override EBox::ServiceModule::ServiceInterface::usedFiles
#
sub usedFiles
{
    return [];
}

# Method: enableActions 
#
#   Override EBox::ServiceModule::ServiceInterface::enableActions
#
sub enableActions
{
}

# Method: serviceModuleName 
#
#   Override EBox::ServiceModule::ServiceInterface::serviceModuleName
#
sub serviceModuleName
{
    return 'maillist';
}

# Method: menu 
#
#       Overrides EBox::Module method.
#   
#
sub menu
{
    my ($self, $root) = @_;
    my $item = new EBox::Menu::Item(
    'url' => 'Maillist/View/Settings',
    'text' => __('Maillist'),
    'order' => 3);
    $root->add($item);
}

1;
