# Copyright (C) 2009 Jorge Bernal <jbernal@ebox-platform.com>
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

package EBox::MailListLdap;

use strict;
use warnings;

use EBox::Sudo qw( :all );
use EBox::Global;
use EBox::Ldap;
use EBox::MailUserLdap;
use EBox::Exceptions::InvalidData;
use EBox::Exceptions::Internal;
use EBox::Exceptions::DataExists;
use EBox::Exceptions::DataMissing;
use EBox::Gettext;

use constant SCHEMAS     => ('/etc/ldap/schemas/maillist.schema');
use constant ALIASDN     => 'ou=mailalias, ou=postfix';

sub new 
{
	my $class = shift;
	my $self  = {};
	$self->{ldap} = EBox::Ldap->instance();
	bless($self, $class);
	return $self;
}

# Method: addMailingList
#
#  Creates a new mailing list
#
# Parameters:
#
#     alias - The mailing list to create
sub addMailingList ($$) { 
	my $self = shift;
	my $alias = shift;
	
	#RFC compliant
	unless ($alias =~ /^[^\.\-][\w\.\-]+\@[^\.\-][\w\.\-]+$/) {
		throw EBox::Exceptions::InvalidData('data' => __('mail account'),
														'value' => $alias);
   }
	# Verify mail exists
	if ($self->accountExists($alias)) {
		throw EBox::Exceptions::DataExists('data' => __('mail account'),
														'value' => $alias);
	}
	
	my $dn = "mail=$alias, " . $self->mailListDn();
	my %attrs = ( 
		attr => [
			'objectclass'		=> 'couriermailalias',
			'objectclass'		=>	'account',
			'userid'				=> $alias,
			'mail'				=>	$alias		]
	);

	my $r = $self->{'ldap'}->add($dn, \%attrs);
}

# Method: addMaildrop
#
#	This method adds a new maildrop to an existing mail alias account (used on
#	group mail alias accounts).
#
# Parameters:
#
#     alias - The mail alias account to create
#		maildrop - The mail account to add to the alias account
sub addMaildrop ($$$) { #alias account, mail account to add
	my $self = shift;
	my $alias = shift;
	my $maildrop = shift;

	unless ($self->aliasExists($alias)) {
		throw EBox::Exceptions::DataNotFound('data' => __('mail alias account'),
														'value' => $alias);
	}

	my $dn = "mail=$alias, " . $self->mailListDn();

	my %attrs = (
		changes => [
			add => [ 'maildrop'	=> $maildrop ]
		]
	);

	my $r = $self->{'ldap'}->modify($dn, \%attrs);
}

# Method: delMaildrop
#
#	This method removes a maildrop to an existing mail alias account (used on
#	group mail alias accounts).
#
# Parameters:
#
#     alias - The mail alias account to create
#		maildrop - The mail account to add to the alias account
sub delMaildrop ($$$) { #alias account, mail account to remove
	my $self = shift;
	my $alias = shift;
	my $maildrop = shift;

	unless ($self->aliasExists($alias)) {
		throw EBox::Exceptions::DataNotFound('data' => __('mail alias account'),
														'value' => $alias);
	}

	my $dn = "mail=$alias, " . $self->mailListDn();

	#if is the last maildrop delete the alias account
	my @mlist = @{$self->accountListByAliasGroup($alias)};
	my %attrs;

	if (@mlist == 1) {
		$self->delAlias($alias);
	} else {
		%attrs = (
			changes => [
				delete => [ 'maildrop'	=> $maildrop ]
			]
		);
		my $r = $self->{'ldap'}->modify($dn, \%attrs);
	}	

}

# Method: delAlias
#
#	This method removes a mail alias account
#
# Parameters:
#
#     alias - The mail alias account to create
sub delAlias($$) { #mail alias account
	my $self = shift;
	my $alias = shift;

	unless ($self->aliasExists($alias)) {
		throw EBox::Exceptions::DataNotFound('data' => __('mail alias account'),
														'value' => $alias);
	}

	# We Should warn about users whose mail account belong to this vdomain.

	my $r = $self->{'ldap'}->delete("mail=$alias, " . $self->mailListDn);
}

# Method: mailListDn
#
#	This method returns the DN of alias ldap leaf
#
# Returns:
#
#     string - DN of alias leaf
sub mailListDn
{
	my $self = shift;
	return ALIASDN . ", " . $self->{ldap}->dn;
}

# Method: aliasExists
#
#	This method returns wether a given alias exists
#
# Parameters:
#
#     mail - The mail account 
sub mailingListExists($$) { #mail alias 
	my $self = shift;
	my $alias = shift;

	my %attrs = (
		base => $self->mailListDn,
		filter => "&(objectclass=couriermailalias)(mail=$alias)",
		scope => 'one'
	);

	my $result = $self->{'ldap'}->search(\%attrs);

	return ($result->count > 0);
}

sub _includeLDAPSchemas 
{
    my ($self) = @_;

    return [] unless (EBox::Global->modInstance('mail')->configured());

    my @schemas = SCHEMAS;
    
    return \@schemas;
}

1;

