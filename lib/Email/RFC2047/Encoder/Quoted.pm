package Email::RFC2047::Encoder::Quoted;

use strict;

use base qw(Email::RFC2047::Encoder::WordEncoder);

sub flush {
    my $self = shift;

    my $result = $self->{result};

    $$result .= ' ' if $$result ne '';

    my $buffer = $self->{buffer};

    if($buffer =~ /[()<>@,;:\\".\[\]]/) {
        $buffer =~ s/[\\"]/\\$&/g;
        
        $$result .= qq("$buffer");
    }
    else {
        $$result .= $buffer;
    }
}

sub add_word {
    my ($self, $word) = @_;

    if($self->{buffer} eq '') {
        $self->{buffer} = $word;
    }
    else {
        $self->{buffer} .= " $word";
    }
}

1;

