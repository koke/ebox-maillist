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

# Class: EBox::Maillist::Model::Settings
#   
#   TODO: Document class
#

package EBox::Maillist::Model::Settings;

use EBox::Gettext;
use EBox::Validate qw(:all);

use EBox::Types::Text;
use EBox::Types::Text;

use strict;
use warnings;

use base 'EBox::Model::DataForm';

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
        new EBox::Types::Text(
            'fieldName' => 'field1',
            'printableName' => __('field1'),
            'size' => '8',
            'unique' => 1,
            'editable' => 1
        ),
        new EBox::Types::Text(
            'fieldName' => 'field2',
            'printableName' => __('field2'),
            'size' => '8',
            'unique' => 1,
            'editable' => 1
        ),
    );
    my $dataTable = 
    { 
        'tableName' => 'Settings',
        'printableTableName' => __('Settings'),
        'modelDomain' => 'Maillist',
        'defaultActions' => ['add', 'del', 'editField', 'changeView' ],
        'tableDescription' => \@tableHead,
        'help' => '', # FIXME
    };

    return $dataTable;
}

1;
