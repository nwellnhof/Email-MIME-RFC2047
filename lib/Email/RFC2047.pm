package Email::RFC2047;

1;

__END__

=head1 NAME

Email::RFC2047 - Correct handling of non-ASCII MIME headers

=head1 SYNOPSIS

 use Email::RFC2047::Encoder;
 
 my $encoder = Email::RFC2047::Encoder->new(
     encoding => 'utf-8',
     method   => 'Q',
 );
 
 my $encoded_text   = $encoder->encode_text($string);
 my $encoded_phrase = $encoder->encode_phrase($string);
 
 use Email::RFC2047::Decoder;
 
 my $decoder = Email::RFC2047::Decoder->new();
 
 my $string = $decoder->decode_text($encoded_text);
 my $string = $decoder->decode_phrase($encoded_phrase);

=head1 DESCRIPTION

This set of modules tries to provide a usable implementation of RFC 2047
"MIME Part Three: Message Header Extensions for Non-ASCII Text". The
L<Encode> module also provides RFC 2047 encoding and decoding but it still
has some bugs regarding strict standards compatibility. More importantly,
a useful API should handle the different situations where RFC 2047
encoded headers are used. Section 5. of the RFC defines three use cases
for 'encoded-words':

(1) As a replacement of 'text' tokens, for example in a Subject header

(2) In comments, this case isn't handled by this module

(3) As a replacement for a 'word' entity within a 'phrase', for example,
one that precedes an address in a From, To, or Cc header

See L<Email::RFC2047::Encoder> for encoding

See L<Email::RFC2047::Decoder> for decoding

=head1 AUTHOR

Nick Wellnhofer <wellnhofer@aevum.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) Nick Wellnhofer, 2009

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

