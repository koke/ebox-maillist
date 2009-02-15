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

# Class: EBox::Maillist::Model::Lists
#   
#   TODO: Document class
#

package EBox::Maillist::Model::Lists;

use EBox::Gettext;
use EBox::Validate qw(:all);

use EBox::Types::Text;
use EBox::Types::Select;
use EBox::Types::Boolean;
use EBox::Types::Select;

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

# Method: populate_domain
#
#   Callback function to fill out the values that can
#   be picked from the <EBox::Types::Select> field domain
#
# Returns:
#   
#   Array ref of hash refs containing:
#    
#
sub populate_domain
{
    my $mail = EBox::Global->modInstance('mail');
    my @vdomains = $mail->{vdomains}->vdomains();
    my @options;

    foreach my $vdomain (@vdomains) {
        push(@options, { value => $vdomain, printableValue => $vdomain });
    }
    return \@options;
}
# Method: populate_fileLimit
#
#   Callback function to fill out the values that can
#   be picked from the <EBox::Types::Select> field fileLimit
#
# Returns:
#   
#   Array ref of hash refs containing:
#    
#
sub populate_fileLimit
{
    return [
            { 
                value => '0', 
                printableValue => __('No limit')
            },
            { 
                value => '524288', 
                printableValue => '512K'
            },
            { 
                value => '1048576', 
                printableValue => '1M'
            },
            { 
                value => '5242880', 
                printableValue => '5M'
            }
    ];
}

sub _table
{

    my @tableHead = 
    ( 
        new EBox::Types::Text(
            'fieldName' => 'name',
            'printableName' => __('List'),
            'size' => '8',
            'unique' => 1,
            'editable' => 1
        ),
        new EBox::Types::Select(
            'fieldName' => 'domain',
            'printableName' => __('Domain'),
            'populate' => \&populate_domain,
            'unique' => 0,
            'editable' => 1
        ),
        new EBox::Types::Boolean(
            'fieldName' => 'private',
            'printableName' => __('Private list'),
            'size' => '8',
            'unique' => 0,
            'editable' => 1
        ),
        new EBox::Types::Select(
            'fieldName' => 'fileLimit',
            'printableName' => __('Attachment size limit'),
            'populate' => \&populate_fileLimit,
            'unique' => 0,
            'editable' => 1
        ),
        new EBox::Types::HasMany(
            'fieldName' => 'subscribers',
            'printableName' => __('Subscribers'),
            'foreignModel' => 'Subscribers',
            'view' => '/ebox/Maillist/View/Subscribers',
        ),
    );
    my $dataTable = 
    { 
        'tableName' => 'Lists',
        'printableTableName' => __('Lists'),
        'printableRowName' => __('List'),
        'modelDomain' => 'Maillist',
        'defaultActions' => ['add', 'del', 'editField', 'changeView' ],
        'tableDescription' => \@tableHead,
        'help' => '', # FIXME
    };

    return $dataTable;
}

1;
