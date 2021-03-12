###############################################################################
# Description:  Reports the status of the current session.  Are we logged-in,
#               what groups do we belong to, etc...
#
# Licence:
#       This file is part of the Jarvis WebApp/Database gateway utility.
#
#       Jarvis is free software: you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation, either version 3 of the License, or
#       (at your option) any later version.
#
#       Jarvis is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with Jarvis.  If not, see <http://www.gnu.org/licenses/>.
#
#       This software is Copyright 2008 by Jonathan Couper-Smartt.
###############################################################################
#
use strict;
use warnings;

use XML::LibXML;

package Jarvis::Habitat;

use Jarvis::Text;
use Jarvis::Error;

################################################################################
# Returns the "habitat" parameters which an application might use to help
# determine how to run.  Habitat could be things like "Am I production or
# development".  Basically, it allows your application to have a simple way
# to access some static configuration parameters.
#
# Params:
#       $jconfig - Jarvis::Config object
#           READ: xml
#
# Returns:
#       1.
#       die on error.
################################################################################
#
sub print {
    my ($jconfig) = @_;

    my $xml = $jconfig->{'xml'};

    # Parse the habitat nodes from the jarvis config or use an empty new object.
    my $cxml = $xml->find ('/jarvis/app/habitat')->pop ();

    # If there is no xml configuration generate an empty habitat.
    if (! defined ($cxml)) {
        # Don't generate the headers for new XML documents.
        $XML::LibXML::skipXMLDeclaration = 1;

        # Create a new document and add an empty habitat element. For XML we will return this document. JSON will strip it.
        $cxml = XML::LibXML::Document->new ("1.0", "UTF-8");
        my $habitat_node = $cxml->createElement ("habitat");
        $cxml->setDocumentElement ($habitat_node);
    }

    # Output the CXML as a string, using 1 for pretty print indenting.
    my $content = $cxml->toString (1);

    # Strip the outer <habitat></habitat> for non-XML.  That is the only concession
    # we make to the JSON format.  If you want a JSON habitat, then I recommend
    # you use <![CDATA[ as per demo.xml and put JSON in there.
    #
    if ($jconfig->{'format'} ne "xml") {
        $content =~ s/^\s*<habitat[^>]*>\s*//si;
        $content =~ s/\s*<\/habitat>\s*$//i;
    }

    return $content;
}

1;
