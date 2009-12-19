package Email::MIME::RFC2047::Group;

use strict;
use base qw(Email::MIME::RFC2047::Address);

use Email::MIME::RFC2047::Decoder;
use Email::MIME::RFC2047::MailboxList;

sub new {
    my $class = shift;

    my $self;

    if(@_ >= 2) {
        $self = { @_ };
    }
    else {
        $self = $_[0];
    }

    return bless($self, $class);
}

# unused
sub _parse {
    my ($class, $string, $decoder) = @_;
    my $string_ref = ref($string) ? $string : \$string;

    $decoder ||= Email::MIME::RFC2047::Decoder->new();
    my $name = $decoder->decode_phrase($string_ref);

    $$string_ref =~ /\G:/cg or die("can't parse group");

    my $mailbox_list = Email::MIME::RFC2047::MailboxList->parse(
        $string_ref, $decoder
    );

    $$string_ref =~ /\G;\s*/cg or die("can't parse group");

    my $group = $class->new(
        name         => $name,
        mailbox_list => $mailbox_list,
    );

    if(!ref($string) && pos($string) < length($string)) {
        die("invalid characters after group\n");
    }

    return $group;
}

sub name {
    my $self = shift;
    
    my $old_name = $self->{name};
    $self->{name} = $_[0] if @_;

    return $old_name;
}

sub mailbox_list {
    my $self = shift;
    
    my $old_mailbox_list = $self->{mailbox_list};
    $self->{mailbox_list} = $_[0] if @_;

    return $old_mailbox_list;
}

sub format {
    my ($self, $encoder) = @_;
    $encoder ||= Email::MIME::RFC2047::Encoder->new();

    return
        $encoder->encode_phrase($self->{name}) .
        ': ' .
        $self->{mailbox_list}->format($encoder) .
        ';';
}

1;

__END__

=head1 NAME

Email::MIME::RFC2047::Group - Handling of MIME encoded mailbox groups

=head1 SYNOPSIS

 use Email::MIME::RFC2047::Group;

 my $group = Email::MIME::RFC2047::Group->new(
    name => $name,
    mailbox_list => $mailbox_list,
 );
 $email->header_set('To', $group->format());

=head1 DESCRIPTION

This module handles RFC 2822 'groups'.

=head1 CONSTRUCTOR

=head2 new

 my $group = Email::MIME::RFC2047::Group->new(
    name => $name,
    mailbox_list => $mailbox_list,
 );

Creates a new Email::MIME::RFC2047::Group object, optionally with a
display name $name and an mailbox list $mailbox_list.

=head1 METHODS

=head2 name

 my $name = $group->name();
 $group->name($new_name);

Gets or sets the display name of the group.

=head2 mailbox_list

 my $mailbox_list = $group->mailbox_list();
 $group->mailbox_list($new_mailbox_list);

Gets or sets the mailbox list of the group.

=head2 format

 my $string = $group->format([$encoder]);

Returns the formatted string for use in a message header.

$encoder is an optional L<Email::MIME::RFC2047::Encoder> object used for
encoding display names with non-ASCII characters.

=head1 AUTHOR

Nick Wellnhofer <wellnhofer@aevum.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) Nick Wellnhofer, 2009

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

