const int minUsernameLength = 3;
const int maxUsernameLength = 40;

const int maxNameLength = 50;

const int minPasswordLength = 8;
const int maxPasswordLength = 16;
const String validPasswordRegex =
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,16}$";
