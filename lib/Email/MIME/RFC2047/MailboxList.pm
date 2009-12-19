package Email::MIME::RFC2047::MailboxList;

use strict;
use base qw(Email::MIME::RFC2047::AddressList);

use Email::MIME::RFC2047::Mailbox;

sub _parse_item {
    my ($class, $string_ref, $decoder) = @_;

    return Email::MIME::RFC2047::Mailbox->parse(
        $string_ref, $decoder
    );
}

1;

__END__

=head1 NAME

Email::MIME::RFC2047::MailboxList - Handling of MIME encoded mailbox lists

=head1 SYNOPSIS

 use Email::MIME::RFC2047::MailboxList;

 my $mailbox_list = Email::MIME::RFC2047::MailboxList->parse($string);
 my @items = $mailbox_list->items();

 my $mailbox_list = Email::MIME::RFC2047::MailboxList->new();
 $mailbox_list->push($mailbox);
 $email->header_set('To', $mailbox_list->format());

=head1 DESCRIPTION

This module handles RFC 2822 'mailbox-lists'. It is a subclass of
L<Email::MIME::RFC2047::AddressList> and works the same but only allows
L<Email::MIME::RFC2047::Mailbox> items.

=head1 AUTHOR

Nick Wellnhofer <wellnhofer@aevum.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) Nick Wellnhofer, 2009

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

