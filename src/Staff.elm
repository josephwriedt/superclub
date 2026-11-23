module Staff exposing (Staff, StaffOrPlaceholder(..))


-- Staff details can be expanded as staff mechanics are introduced.
type alias Staff =
    { name : String
    , role : String
    }


type StaffOrPlaceholder
    = StaffMember Staff
    | StaffPlaceholder String
