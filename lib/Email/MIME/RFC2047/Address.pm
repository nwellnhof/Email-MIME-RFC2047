package Email::MIME::RFC2047::Address;

use strict;

use Email::MIME::RFC2047::Decoder;
use Email::MIME::RFC2047::Group;
use Email::MIME::RFC2047::Mailbox;
use Email::MIME::RFC2047::MailboxList;

my $domain_part = qr/[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?/;
my $addr_spec = qr/[\w.-]+\@$domain_part(?:\.$domain_part)+/;

sub parse {
    my ($class, $string, $decoder) = @_;
    my $string_ref = ref($string) ? $string : \$string;

    my $address;

    if($$string_ref =~ /\G\s*($addr_spec)\s*/cg) {
        $address = Email::MIME::RFC2047::Mailbox->new($1);
    }
    else {
        $decoder ||= Email::MIME::RFC2047::Decoder->new();
        my $name = $decoder->decode_phrase($string_ref);

        if($$string_ref =~ /\G<\s*($addr_spec)\s*>\s*/cg) {
            my $addr_spec = $1;

            $address = Email::MIME::RFC2047::Mailbox->new(
                name    => $name,
                address => $addr_spec,
            );
        }
        elsif($$string_ref =~ /\G:/cg) {
            my $mailbox_list;

            if($$string_ref =~ /\G\s*;\s*/cg) {
                $mailbox_list = Email::MIME::RFC2047::MailboxList->new();
            }
            else {
                $mailbox_list = Email::MIME::RFC2047::MailboxList->parse(
                    $string_ref, $decoder
                );

                $$string_ref =~ /\G;\s*/cg or die("can't parse group");
            }

            $address = Email::MIME::RFC2047::Group->new(
                name         => $name,
                mailbox_list => $mailbox_list,
            );
        }
        else {
            die("can't parse address");
        }
    }

    if(!ref($string) && pos($string) < length($string)) {
        die("invalid characters after address\n");
    }

    return $address;
}

1;

__END__

=head1 NAME

Email::MIME::RFC2047::Address - Handling of MIME encoded addresses

=head1 SYNOPSIS

 use Email::MIME::RFC2047::Address;

 my $address = Email::MIME::RFC2047::Address->parse($string);

 if($address->isa('Email::MIME::RFC2047::Mailbox')) {
    print $address->name(), "\n";
    print $address->address(), "\n";
 }

=head1 DESCRIPTION

This is the superclass for L<Email::MIME::RFC2047::Mailbox> and
L<Email::MIME::RFC2047::Group>.

=head1 CLASS METHODS

=head2 parse

 my $address = Email::MIME::RFC2047::Address->parse($string, [$decoder])

Parses a RFC 2822 'address'. Returns either a L<Email::MIME::RFC2047::Mailbox>
or a L<Email::MIME::RFC2047::Group> object.

=head1 AUTHOR

Nick Wellnhofer <wellnhofer@aevum.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) Nick Wellnhofer, 2009

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

