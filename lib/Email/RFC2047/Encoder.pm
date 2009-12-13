package Email::RFC2047::Encoder;

use strict;

use Email::RFC2047::Encoder::MIME_B;
use Email::RFC2047::Encoder::MIME_Q;
use Email::RFC2047::Encoder::Quoted;

sub new {
    my $package = shift;
    my $options = ref($_[0]) ? $_[0] : { @_ };

    my ($encoding, $type) = ($options->{encoding}, $options->{type});

    if(!defined($encoding)) {
        $encoding = 'utf-8';
        $type = 'Q' if !defined($type);
    }
    else {
        $type = 'B' if !defined($type);
    }

    my $self = {
        encoding => $encoding,
        type     => uc($type),
    };

    return bless($self, $package);
}

sub encode_text {
    my ($self, $string) = @_;

    return $self->encode('text', $string);
}

sub encode_phrase {
    my ($self, $string) = @_;

    return $self->encode('phrase', $string);
}

sub encode {
    my ($self, $mode, $string) = @_;

    my $result = '';

    my $quoted_encoder = Email::RFC2047::Encoder::Quoted->new(
        result => \$result,
    ) if $mode eq 'phrase';
    my $mime_package = "Email::RFC2047::Encoder::MIME_$self->{type}";
    my $mime_encoder = $mime_package->new(
        result => \$result,
        encoding => $self->{encoding},
    );
    my $word_encoder;

    for my $word (split(/[ \t\r\n]+/, $string)) {
        next if $word eq ''; # ignore leading white space

        $word =~ s/[\x00-\x1f\x7f]//g; # better remove control chars

        my $word_type;

        if($word =~ /[\x80-\x{ffff}]/) {
            $word_type = 'mime';
        }
        elsif($mode eq 'phrase') {
            $word_type = 'quoted';
        }
        else {
            $word_type = 'text';
        }
        
        if($word_type eq 'text') {
            $word_encoder->finish() if $word_encoder;
            $word_encoder = undef;

            $result .= ' ' if $result ne '';
            $result .= $word;
        }
        else {
            my $new_word_encoder = $word_type eq 'mime' ?
                $mime_encoder :
                $quoted_encoder;

            if($word_encoder && $word_encoder != $new_word_encoder) {
                $word_encoder->finish();
                $word_encoder = undef;
            }

            $word_encoder ||= $new_word_encoder;
            $word_encoder->add_word($word);
        }
    }

    $word_encoder->finish() if $word_encoder;

    return $result;
}

1;

