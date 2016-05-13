package Email::MIME::RFC2047::Parser;

use strict;
use warnings;

# ABSTRACT: Base class for parsers

sub _parse_error {
    my ($class, $string_ref, $what) = @_;

    my $text;
    my $pos = pos($$string_ref);
    $pos = 0 if !defined($pos);

    if ($pos < length($$string_ref)) {
        my $char = substr($$string_ref, $pos, 1);
        $text = defined($what) ?
            "invalid $what at character '$char', pos $pos in string" :
            "unexpected character '$char' at pos $pos in string";
    }
    else {
        $text = defined($what) ?
            "incomplete or missing $what at end of string" :
            "unexpected end of string";
    }

    die("Parse error in MIME header: $text $$string_ref\n");
}

1;

__END__

=head1 DESCRIPTION

This is a base class for the packages parsing address headers.

=cut

