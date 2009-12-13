package Email::RFC2047::Encoder::MIME_Q;

use strict;

use base qw(Email::RFC2047::Encoder::WordEncoder);

use Encode ();

sub flush {
    my $self = shift;

    my $result = $self->{result};

    $$result .= ' ' if $$result ne '';
    $$result .= "=?$self->{encoding}?Q?$self->{buffer}?=";
}

sub add_word {
    my ($self, $word) = @_;

    my $max_len = 75 - 7 - length($self->{encoding});
    my $buf_len = length($self->{buffer});

    if($buf_len > 0) {
        if($buf_len + 1 <= $max_len) {
            $self->{buffer} .= '_';
        }
        else {
            $self->flush();
            $self->{buffer} = '_';
        }
    }

    for my $char (split(//, $word)) {
        my $chunk = '';

        if($char =~ /[()<>@,;:\\".\[\]=?_\x80-\x{ffff}]/) {
            my $encoded_char = Encode::encode($self->{encoding}, $char);
            
            for my $byte (unpack('C*', $encoded_char)) {
                $chunk .= sprintf('=%02x', $byte);
            }
        }
        else {
            $chunk = $char;
        }

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

