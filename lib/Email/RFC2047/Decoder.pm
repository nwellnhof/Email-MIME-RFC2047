package Email::RFC2047::Decoder;

use strict;

use Encode ();

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
            my ($encoding, $method, $content) = ($1, uc($2), $3);

            if($method eq 'Q') {
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

__END__

=head1 NAME

Email::RFC2047::Decoder - Decoding of non-ASCII MIME headers

=head1 SYNOPSIS

 use Email::RFC2047::Decoder;
 
 my $decoder = Email::RFC2047::Decoder->new();
 
 my $string = $decoder->decode_text($encoded_text);
 my $string = $decoder->decode_phrase($encoded_phrase);

=head1 DESCRIPTION

This module decodes parts of MIME email message headers containing non-ASCII
text according to RFC 2047.

=head1 CONSTRUCTOR

=head2 new

 my $decoder = Email::RFC2047::Decoder->new();

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

