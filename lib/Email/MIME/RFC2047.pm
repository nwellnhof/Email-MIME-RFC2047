package Email::MIME::RFC2047;

1;

__END__

=head1 NAME

Email::MIME::RFC2047 - Correct handling of non-ASCII MIME headers

=head1 SYNOPSIS

 use Email::MIME;

 # create headers with non-ASCII chars

 use Email::MIME::RFC2047::Encoder;
 use Email::MIME::RFC2047::Mailbox;
  
 my $email = Email::MIME->create();
 my $encoder = Email::MIME::RFC2047::Encoder->new(
     encoding => 'utf-8',
     method   => 'Q',
 );
 
 $email->header_set(Subject => $encoder->encode_text($non_ascii_subject));

 my $to_address = Email::MIME::RFC2047::Mailbox->new(
    name    => $non_ascii_name,
    address => $email_address,
 );
 $email->header_set(To => $to_address->format($encoder));
 
 # parse headers with non-ASCII chars

 use Email::MIME::RFC2047::Decoder;

 my $email = Email::MIME->new($message);
 my $decoder = Email::MIME::RFC2047::Decoder->new();
 
 my $subject = $decoder->decode_text($email->header('Subject'));

 my $to_address = Email::MIME::RFC2047::AddressList->parse(
    $email->header('To')
 );

=head1 DESCRIPTION

This set of modules tries to provide a correct and usable implementation of
RFC 2047 "MIME Part Three: Message Header Extensions for Non-ASCII Text". The
L<Encode> module also provides RFC 2047 encoding and decoding but it still
has some bugs regarding strict standards compatibility. More importantly,
a useful API should handle the different situations where RFC 2047
encoded headers are used. Section 5 of the RFC defines three use cases
for 'encoded-words':

(1) As a replacement of 'text' tokens, for example in a Subject header

(2) In comments, this case isn't handled by this module

(3) As a replacement for a 'word' entity within a 'phrase', for example,
one that precedes an address in a From, To, or Cc header

Especially, case (3) requires the handling of quoted strings as defined by
RFC 822. So the encoding and decoding modules provides separate methods for
the handling of text and phrases.

Since parsing and encoding of phrases makes up the bulk of handling address
headers like From, To or Cc, some modules to handle these headers are
included.

See L<Email::MIME::RFC2047::Encoder> for encoding

See L<Email::MIME::RFC2047::Decoder> for decoding

See L<Email::MIME::RFC2047::Mailbox> for handling of Sender headers

See L<Email::MIME::RFC2047::MailboxList> for handling of From headers

See L<Email::MIME::RFC2047::AddressList> for handling of Reply-To, To, Cc
and Bcc headers

=head1 AUTHOR

Nick Wellnhofer <wellnhofer@aevum.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) Nick Wellnhofer, 2009

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

