package Email::MIME::RFC2047::AddressList;

use strict;

use Email::MIME::RFC2047::Decoder;
use Email::MIME::RFC2047::Address;

sub new {
    my $class = shift;

    my $self = [ @_ ];

    return bless($self, $class);
}

sub parse {
    my ($class, $string, $decoder) = @_;
    my $string_ref = ref($string) ? $string : \$string;
    $decoder ||= Email::MIME::RFC2047::Decoder->new();
    
    my @addresses;

    do {
        my $address = $class->_parse_item($string_ref, $decoder); 
        push(@addresses, $address);
    } while($$string_ref =~ /\G,/cg);
    
    if(!ref($string) && pos($string) < length($string)) {
        die("invalid characters after address list\n");
    }

    return $class->new(@addresses);
}

sub _parse_item {
    my ($class, $string_ref, $decoder) = @_;

    return Email::MIME::RFC2047::Address->parse(
        $string_ref, $decoder
    );
}

sub items {
    my $self;

    return @$self;
}

sub push {
    my $self = shift;

    push(@$self, @_);
}

sub format {
    my ($self, $encoder) = @_;

    return join(', ', map { $_->format($encoder) } @$self);
}

1;

__END__

=head1 NAME

Email::MIME::RFC2047::AddressList - Handling of MIME encoded address lists

=head1 SYNOPSIS

 use Email::MIME::RFC2047::AddressList;

 my $address_list = Email::MIME::RFC2047::AddressList->parse($string);
 my @items = $address_list->items();

 my $address_list = Email::MIME::RFC2047::AddressList->new();
 $address_list->push($mailbox);
 $address_list->push($group);
 $email->header_set('To', $address_list->format());

=head1 DESCRIPTION

This module handles RFC 2822 'address-lists'.

=head1 CLASS METHODS

=head2 parse

 my $address_list = Email::MIME::RFC2047::AddressList->parse(
    $string, [$decoder]
 );

Parse a RFC 2822 'address-list'. Returns a Email::MIME::RFC2047::AddressList
object.

=head1 CONSTRUCTOR

=head2 new

 my $address_list = Email::MIME::RFC2047::AddressList->new([@items]);

Creates a new Email::MIME::RFC2047::AddressList object, with optional items
@items.

=head1 METHODS

=head2 items

 my @items = $address_list->items();

Gets the items of the address list.

=head2 push

 $address_list->address(@items);

Appends items to the address list.

=head2 format

 my $string = $address_list->format([$encoder]);

Returns the formatted address list string for use in a message header.

$encoder is an optional Email::MIME::RFC2047::Encoder object used for
encoding display names with non-ASCII characters.

=head1 AUTHOR

Nick Wellnhofer <wellnhofer@aevum.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) Nick Wellnhofer, 2009

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

