package Email::MIME::RFC2047::MailboxList;

use strict;
use warnings;

# ABSTRACT: Handling of MIME encoded mailbox lists

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

=cut

