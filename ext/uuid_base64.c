#include <uuid/uuid.h>

#include "uuid_base64.h"

void
uuid_encode64(const uuid_t uu, char *str)
{
  int i;

  for( i=0; i<5; i++ )
  {
    *str++ = e64[  uu[0] >> 2];
    *str++ = e64[((uu[0] << 4) & 0x30) | (uu[1] >> 4)];
    *str++ = e64[((uu[1] << 2) & 0x3c) | (uu[2] >> 6)];
    *str++ = e64[  uu[2] & 0x3f];
    uu += 3;
  }

  *str++ = e64[ uu[0] >> 2];
  *str++ = e64[(uu[0] << 4) & 0x30];
  *str++ = '\0';
}

int
uuid_decode64(const char *str, uuid_t uu)
{
  int           i, j;
  unsigned char buf[3];

  for( i=0; i<5; i++ )
  {
    buf[0] = (unsigned char)  d64[str[0]] << 2 | d64[str[1]] >> 4;
    buf[1] = (unsigned char)  d64[str[1]] << 4 | d64[str[2]] >> 2;
    buf[2] = (unsigned char) (d64[str[2]] << 6) & 0xc0 | d64[str[3]];

    for( j=0; j<3; j++ )
      if( buf[j] != -1 )
        *uu++ = buf[j];
      else
        return buf[j];

    str += 4;
  }

  buf[0] = (unsigned char) d64[str[0]] << 2 | d64[str[1]] >> 4;
  if( buf[0] != -1 )
    *uu++ = buf[0];
  else
    return buf[0];

  return 0;
}
