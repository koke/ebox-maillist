# Copyright  
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

# Class: EBox::Maillist::Model::Subscribers
#   
#   TODO: Document class
#

package EBox::Maillist::Model::Subscribers;

use EBox::Gettext;
use EBox::Validate qw(:all);

use EBox::Types::EmailAddress;

use strict;
use warnings;

use base 'EBox::Model::DataTable';

sub new 
{
        my $class = shift;
        my %parms = @_;

        my $self = $class->SUPER::new(@_);
        bless($self, $class);

        return $self;
}


sub _table
{

    my @tableHead = 
    ( 
        new EBox::Types::EmailAddress(
            'fieldName' => 'subscriber',
            'printableName' => __('Subscriber email'),
            'size' => '30',
            'unique' => 1,
            'editable' => 1
        ),
    );
    my $dataTable = 
    { 
        'tableName' => 'Subscribers',
        'printableTableName' => __('Subscribers'),
        'printableRowName' => __('Subscriber'),
        'modelDomain' => 'Maillist',
        'defaultActions' => ['add', 'del', 'editField', 'changeView' ],
        'tableDescription' => \@tableHead,
        'help' => '', # FIXME
    };

    return $dataTable;
}

1;
