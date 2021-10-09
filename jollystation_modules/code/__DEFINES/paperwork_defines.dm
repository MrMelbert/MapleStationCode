/// -- Paperwork defines. --
/// States of success or failure for paperwork.
#define PAPERWORK_SUCCESS 0
#define FAIL_NO_ANSWER 1
#define FAIL_NO_STAMP 2
#define FAIL_QUESTION_WRONG 3
#define FAIL_NOT_DENIED 4
#define FAIL_INCORRECTLY_DENIED 5

/// The file containing the paperwork strings.
#define PAPERWORK_FILE "paperwork.json"

/// String defines for admin fax machines.
#define SYNDICATE_FAX_MACHINE "the Syndicate"
#define CENTCOM_FAX_MACHINE "Central Command"

/// Global list of all admin fax machine destinations
GLOBAL_LIST_INIT(admin_fax_destinations, list(SYNDICATE_FAX_MACHINE, CENTCOM_FAX_MACHINE))

/// Text macro for replying to a message with a paper fax.
#define ADMIN_FAX_REPLY(machine) "(<a href='?_src_=holder;[HrefToken(TRUE)];FaxReply=[REF(machine)]'>FAX</a>)"
