package Email::MIME::RFC2047::Encoder::MIME_B;

use strict;

use base qw(Email::MIME::RFC2047::Encoder::WordEncoder);

use Encode ();
use MIME::Base64 ();

sub flush {
    my $self = shift;

    my $result = $self->{result};

    $$result .= ' ' if $$result ne '';

    my $base64 = MIME::Base64::encode_base64($self->{buffer}, '');
    $$result .= "=?$self->{encoding}?B?$base64?=";
}

sub add_word {
    my ($self, $word) = @_;

    my $max_len = 3 * ((75 - 7 - length($self->{encoding})) >> 2);

    my @chars;
    push(@chars, ' ') if $self->{buffer} ne '';
    push(@chars, split(//, $word));

    for my $char (@chars) {
        my $chunk = Encode::encode($self->{encoding}, $char);

        if(length($self->{buffer}) + length($chunk) <= $max_len) {
            $self->{buffer} .= $chunk;
        }
        else {
            $self->flush();
            $self->{buffer} = $chunk;
        }
    }
}

1;

