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

use constant TRANSPORTFILE			=> '/etc/postfix/transport';

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
            printableName => __('Mailing lists'),
            domain => 'ebox-maillist',
            @_);

    bless($self, $class);
    return $self;
}

#  Method: enableModDepends
#
#   Override EBox::Module::Service::enableModDepends
#
sub enableModDepends
{
    my ($self) = @_;
    my @depends =  ('mail');

    return \@depends;
}

## api functions

# Overrides:
#
#       <EBox::Model::ModelProvider::modelClasses>
sub modelClasses 
{
    return [
        'EBox::Maillist::Model::Lists',
        'EBox::Maillist::Model::Subscribers',
    ];
}

# Overrides:
#
#       <EBox::Model::ModelProvider::compositeClasses>
sub compositeClassess 
{
    return [
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
    my ($self) = @_;

    return [
            {
              'file' => TRANSPORTFILE,
              'reason' => __('To configure transports for mailman lists'),
              'module' => 'maillist'
            },
    ];
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

sub _regenConfig
{
    my ($self) = @_;

	if ($self->isEnabled()) {
        my @array = ();
        my $mail = EBox::Global->modInstance('mail');
        my @domains = $mail->relayDomains();

        push(@array, 'relayDomains' => \@domains);

        $self->writeConfFile(TRANSPORTFILE, "maillist/transport.mas", \@array);
        EBox::Sudo::root('/usr/sbin/postmap ' . TRANSPORTFILE);
	}
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
    'url' => 'Maillist/View/Lists',
    'text' => __('Mailing lists'),
    'order' => 3);
    $root->add($item);
}

1;
