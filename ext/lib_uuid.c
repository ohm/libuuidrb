#include <ruby.h>
#include <uuid/uuid.h>

#include "uuid_base64.h"
#include "lib_uuid.h"

void
lib_uuid_free(lib_uuid_t *s)
{
  free(s);
}

int
uuid_from_obj(VALUE obj, uuid_t uu)
{
  long len;
  char *ptr;

  if( TYPE(obj) != T_STRING )
    return -1;

  len = RSTRING_LEN(obj);
  ptr = RSTRING_PTR(obj);

  if( len == GUID_STRLEN-1 )
    return uuid_parse(ptr, uu);

  if( len == SHORT_GUID_STRLEN-1)
    return uuid_decode64(ptr, uu);

  return -1;
}

VALUE
lib_uuid_new(unsigned int argc, VALUE *argv, VALUE class)
{
  lib_uuid_t *s;
  uuid_t     parsed_uu;
  VALUE      ret;

  if( argc > 1 )
    rb_raise(rb_eArgError, "too many arguments");

  if( argc == 0 )
    uuid_generate(parsed_uu);

  if( argc == 1 )
  {
    if( uuid_from_obj(argv[0], parsed_uu) == -1 )
      return Qnil;
  }

  s = ALLOC_N(lib_uuid_t, 1);
  uuid_copy(s->uu, parsed_uu);
  ret = Data_Wrap_Struct(class, NULL, lib_uuid_free, s);
  rb_obj_call_init(ret, 0, 0);

  return ret;
}

VALUE
lib_uuid_valid(unsigned int argc, VALUE *argv, VALUE class)
{
  int   i;
  VALUE test[1];

  if( argc == 0 )
    rb_raise(rb_eArgError, "too few arguments");

  for( i=0 ; i<argc ; i++ )
  {
    test[0] = argv[i];
    if( lib_uuid_new(1, test, class) == Qnil )
      return Qfalse;
  }

  return Qtrue;
}

VALUE
lib_uuid_generate_guid(VALUE class)
{
  char   uu_str[GUID_STRLEN];
  uuid_t uu;

  uuid_generate(uu);
  uuid_unparse(uu, uu_str);

  return rb_str_new(uu_str, GUID_STRLEN-1);
}

VALUE
lib_uuid_generate_short_guid(VALUE class)
{
  char   uu_str[SHORT_GUID_STRLEN];
  uuid_t uu;

  uuid_generate(uu);
  uuid_encode64(uu, uu_str);

  return rb_str_new(uu_str, SHORT_GUID_STRLEN-1);
}

VALUE
lib_uuid_initialize(VALUE self)
{
  lib_uuid_t *s;

  Data_Get_Struct(self, lib_uuid_t, s);
  s->guid = s->short_guid = s->type = s->variant = 0;
  rb_iv_set(self, "@bytes", rb_str_new((char *) s->uu, 16));

  return self;
}

VALUE
lib_uuid_bytes(VALUE self)
{
  return rb_iv_get(self, "@bytes");
}

VALUE
lib_uuid_type(VALUE self)
{
  lib_uuid_t *s;

  Data_Get_Struct(self, lib_uuid_t, s);

  if( s->type == 0 )
    s->type = INT2NUM(uuid_type(s->uu));

  return s->type;
}

VALUE
lib_uuid_variant(VALUE self)
{
  lib_uuid_t *s;

  Data_Get_Struct(self, lib_uuid_t, s);

  if( s->variant == 0 )
    s->variant = INT2NUM(uuid_variant(s->uu));

  return s->variant;
}

VALUE
lib_uuid_to_guid(VALUE self)
{
  lib_uuid_t *s;
  char       uu_str[GUID_STRLEN];

  Data_Get_Struct(self, lib_uuid_t, s);

  if( s->guid == 0 )
  {
    uuid_unparse(s->uu, uu_str);
    s->guid = rb_str_new(uu_str, GUID_STRLEN-1);
  }

  return s->guid;
}

VALUE
lib_uuid_to_short_guid(VALUE self)
{
  lib_uuid_t *s;
  char       uu_str[SHORT_GUID_STRLEN];

  Data_Get_Struct(self, lib_uuid_t, s);

  if( s->short_guid == 0 )
  {
    uuid_encode64(s->uu, uu_str);
    s->short_guid = rb_str_new(uu_str, SHORT_GUID_STRLEN-1);
  }

  return s->short_guid;
}

VALUE
lib_uuid_equality(VALUE self, VALUE other)
{
  lib_uuid_t *s, *o;

  if( TYPE(self) != T_DATA || TYPE(other) != T_DATA )
    return Qfalse;

  Data_Get_Struct(self, lib_uuid_t, s);
  Data_Get_Struct(other, lib_uuid_t, o);

  if( uuid_compare(s->uu, o->uu) != 0 )
    return Qfalse;

  return Qtrue;
}

void
Init_lib_uuid()
{
  VALUE m_lib_uuid, c_lib_uuid;

  m_lib_uuid = rb_define_module("LibUUID");
  c_lib_uuid = rb_define_class_under(m_lib_uuid, "UUID", rb_cObject);
  rb_define_singleton_method(c_lib_uuid, "new", lib_uuid_new, -1);
  rb_define_singleton_method(c_lib_uuid, "valid?", lib_uuid_valid, -1);
  rb_define_singleton_method(c_lib_uuid, "guid", lib_uuid_generate_guid, 0);
  rb_define_singleton_method(c_lib_uuid, "short_guid", lib_uuid_generate_short_guid, 0);
  rb_define_method(c_lib_uuid, "initialize", lib_uuid_initialize, 0);
  rb_define_method(c_lib_uuid, "bytes", lib_uuid_bytes, 0);
  rb_define_method(c_lib_uuid, "type", lib_uuid_type, 0);
  rb_define_method(c_lib_uuid, "variant", lib_uuid_variant, 0);
  rb_define_method(c_lib_uuid, "to_guid", lib_uuid_to_guid, 0);
  rb_define_method(c_lib_uuid, "to_short_guid", lib_uuid_to_short_guid, 0);
  rb_define_method(c_lib_uuid, "==", lib_uuid_equality, 1);
}
