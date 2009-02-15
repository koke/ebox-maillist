# Class: EBox::Squid::Composite::Composite
#
#   TODO
#

package EBox::Squid::Composite::Composite;

use base 'EBox::Model::Composite';

use strict;
use warnings;

## eBox uses
use EBox::Gettext;

# Group: Public methods

# Constructor: new
#
#         Constructor for composite
#
# Returns:
#
#       <EBox::Squid::Model::GeneralComposite> - a
#       general events composite
#
sub new
  {

      my ($class, @params) = @_;

      my $self = $class->SUPER::new(@params);

      return $self;

  }

# Group: Protected methods

# Method: _description
#
# Overrides:
#
#     <EBox::Model::Composite::_description>
#
sub _description
  {

      my $description =
        {
         components      => [
                            ],
         layout          => 'top-bottom',
         name            => 'Composite',
         printableName   => __('Composite'),
         compositeDomain => 'Maillist',
#         help            => __(''),
        };

      return $description;

  }

1;
