package Email::RFC2047::Decoder;

use strict;

sub new {
    my $package = shift;

    my $self = {};

    return bless($self, $package);
}

sub decode_text {
    my ($self, $encoded) = @_;

    my $result = '';
    my $prev_enc_flag;

    for my $word (split(/[ \t\r\n]+/, $encoded)) {
        next if $word eq ''; # ignore leading white space

        my ($string, $enc_flag);

        if(
            length($word) <= 75 &&
            $word =~ /
                ^
                =
                \? ( [\w-]+ )
                \? ( [BbQq] )
                \? ( [^?\x00-\x20\x7f-\x{ffff}]+ )
                \?
                =
                \z
            /x
        ) {
            my ($encoding, $type, $content) = ($1, uc($2), $3);

            if($type eq 'Q') {
                $content =~ tr/_/ /;
                $content =~ s/=([0-9A-Fa-f]{2})/chr(hex($1))/eg;
            }
            else {
                $content = MIME::Base64::decode_base64($content);
            }

            $string = Encode::decode($encoding, $content);

            $enc_flag = 1;
        }
        else {
            $string = $word;
        }

        $result .= ' ' unless
            $result eq '' ||
            $enc_flag && $prev_enc_flag;
        $result .= $string;

        $prev_enc_flag = $enc_flag;
    }

    return $result;
}

sub decode_phrase {
    my ($self, $encoded) = @_;

    $encoded =~ s{
        "
        (
            (?:
                [^"\\] |
                \\ .
            )*
        )
        "
    }{
        my $content = $1;
        $content =~ s/\\(.)/$1/gs;
        $content;
    }egsx;

    return $self->decode_text($encoded);
}

1;

