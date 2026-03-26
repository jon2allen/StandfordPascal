# Stanford Pascal P-code Interpreter Makefile
# For FreeBSD 15

PROG=	pcint
SRCS=	pcint.c pcintcmp.c oiscach.c
OBJS=	${SRCS:.c=.o}

LDADD=	-lm

# Enable some hardening and optimization by default
CFLAGS+=	-O2 -Wall -Wextra -Wmissing-prototypes -Wstrict-prototypes -Wformat-security

# Build the executable
all: ${PROG}

${PROG}: ${OBJS}
	${CC} ${CFLAGS} -o ${PROG} ${OBJS} ${LDADD}

# Generic rule for object files
.c.o:
	${CC} ${CFLAGS} -c $< -o $@

# Cleanup
clean:
	rm -f ${PROG} ${OBJS}

# Dependencies (manual for now, could be improved)
pcint.o: pcint.c pcint.h oisavlt.h oiscach.h
pcintcmp.o: pcintcmp.c pcint.h
oiscach.o: oiscach.c oiscach.h
