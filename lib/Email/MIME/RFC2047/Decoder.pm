package Email::MIME::RFC2047::Decoder;

use strict;

use Encode ();
use MIME::Base64 ();

my $encoded_word_re = qr/
    ( ^ | \s+ )
    = \? ( [\w-]+ ) \?
    (?:
        [Bb] \?
        (
            (?:
                [A-Za-z0-9+\/]{2}
                (?: == | [A-Za-z0-9+\/] [A-Za-z0-9+\/=] )
            )+
        ) |
        [Qq] \?
        ( [^?\x00-\x20\x7f-\x{ffff}]+ )
    )
    \? =
    (?= \z | \s+ )
/x;

my $quoted_string_re = qr/
    "
    (
        (?:
            [^"\\] |
            \\ .
        )*
    )
    "
/sx;

sub new {
    my $package = shift;

    my $self = {};

    return bless($self, $package);
}

sub decode_text {
    my ($self, $encoded) = @_;

    return $self->_decode('text', $encoded);
}

sub decode_phrase {
    my ($self, $encoded) = @_;

    return $self->_decode('phrase', $encoded);
}

sub _decode {
    my ($self, $mode, $encoded) = @_;

    my $result = '';
    my $pos = 0;
    my $prev_enc_flag;

    my $regex = $mode eq 'phrase' ?
        qr/$encoded_word_re|$quoted_string_re/ :
        $encoded_word_re;

    while($encoded =~ /\G(.*?)$regex/gs) {
        $pos = pos($encoded);
        my ($atom, $ws, $encoding, $b_content, $q_content, $qs_content) =
            ($1, $2, $3, $4, $5, $6);
        my $enc_flag;

        if(defined($atom)) {
            $result .= $atom;
        }

        if(defined($encoding)) {
            $enc_flag = 1;
            $result .= $ws unless $result eq '' || $prev_enc_flag;

            my $content;

            if(defined($q_content)) {
                $content = $q_content;
                $content =~ tr/_/ /;
                $content =~ s/=([0-9A-Fa-f]{2})/chr(hex($1))/eg;
            }
            else {
                $content = MIME::Base64::decode_base64($b_content);
            }

            $result .= Encode::decode($encoding, $content);
        }
        else {
            $qs_content =~ s/\\(.)/$1/gs;
            $result .= $qs_content;
        }

        $prev_enc_flag = $enc_flag;
    }

    $result .= substr($encoded, $pos);
    
    $result =~ s/^\s+//;
    $result =~ s/\s+\z//;
    $result =~ s/\s+/ /g;

    return $result;
}

1;

__END__

=head1 NAME

Email::MIME::RFC2047::Decoder - Decoding of non-ASCII MIME headers

=head1 SYNOPSIS

 use Email::MIME::RFC2047::Decoder;
 
 my $decoder = Email::MIME::RFC2047::Decoder->new();
 
 my $string = $decoder->decode_text($encoded_text);
 my $string = $decoder->decode_phrase($encoded_phrase);

=head1 DESCRIPTION

This module decodes parts of MIME email message headers containing non-ASCII
text according to RFC 2047.

=head1 CONSTRUCTOR

=head2 new

 my $decoder = Email::MIME::RFC2047::Decoder->new();

Creates a new decoder object.

=head1 METHODS

=head2 decode_text

 my $string = $decoder->decode_text($encoded_text);

Decodes any MIME header field for which the field body is defined as '*text'
(as defined by RFC 822), for example, any Subject or Comments header field.

=head2 decode_phrase

 my $string = $decoder->decode_phrase($encoded_phrase);

Decodes any 'phrase' token (as defined by RFC 822) in a MIME header field,
for example, one that precedes an address in a From, To, or Cc header.

This method works like I<decode_text> but additionally unquotes any
'quoted-strings'.

=head1 AUTHOR

Nick Wellnhofer <wellnhofer@aevum.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) Nick Wellnhofer, 2009

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

