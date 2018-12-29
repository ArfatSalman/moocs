fun is_older(date1: int*int*int, date2: int*int*int) = 
    if (#1 date1 < #1 date2)
    then true
    else
        if (#1 date1 = #1 date2) andalso (#2 date1 < #2 date2)
        then true
        else
            if (#1 date1 = #1 date2) andalso (#2 date1 = #2 date2) andalso (#3 date1 < #3 date2)
            then true
            else false

fun number_in_month(dates: (int*int*int) list, month: int) = 
    if (null dates)
    then 0
    else 
        let
            val current_month = #2 (hd dates);
        in 
            if (current_month = month)
            then 1 + number_in_month(tl dates, month)
            else number_in_month(tl dates, month)
        end

fun number_in_months(dates: (int*int*int) list, months: int list) = 
    if (null months) 
    then 0 
    else number_in_month(dates, hd months) + number_in_months(dates, tl months)

fun dates_in_month(dates: (int*int*int) list, month: int) = 
    if (null dates)
    then []
    else
        if (#2 (hd dates) = month) 
        then dates_in_month(tl dates, month) @ [hd dates]
        else dates_in_month(tl dates, month)

fun dates_in_months(dates: (int*int*int) list, months: int list) = 
    if (null months)
    then []
    else dates_in_month(dates, hd months) @ dates_in_months(dates, tl months)

fun get_nth(strs: string list, index: int) = 
    let fun loop(strs, count: int) = 
        if (index = count) then hd strs else loop(tl strs, count + 1);
    in
        loop(strs, 1)
    end

fun date_to_string(date: int*int*int) = 
    let 
        val dates = [
            "January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
            "November", "December"
        ]
    in 
        get_nth(dates, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end

fun number_before_reaching_sum(sum: int, ints: int list) = 
    let 
        fun loop(ints, partial_sum, count) = 
            if (hd ints + partial_sum >= sum)
            then count
            else loop(tl ints, hd ints + partial_sum, count + 1)
    in
        loop(ints, 0, 0)
    end

fun what_month(day: int) =
    let
        val nums = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    in 
        number_before_reaching_sum(day, nums) + 1
    end

fun month_range(day1: int, day2: int) = 
    if (day1 > day2)
    then []
    else what_month (day1) :: month_range(day1 + 1, day2)

fun oldest (dates: (int*int*int) list) = 
    if (null dates)
    then NONE
    else
        let 
            fun max(dates, older: (int*int*int)) = 
                if (null dates) 
                then older
                else 
                    if (is_older(hd dates, older))
                    then max(tl dates, hd dates)
                    else max(tl dates, older)
        in
            SOME (max(dates, hd dates))
        end

fun remove_duplicates(xs: int list) = 
    let 
        fun exists(xs, x) = 
            if (null xs)
            then false
            else 
                if ((hd xs) = x) 
                then true
                else exists(tl xs, x)
        
        fun loop(xs, acc) = 
            if (null xs) 
            then acc
            else 
                if (exists(acc, hd xs))
                then loop(tl xs, acc)
                else loop(tl xs, acc @ [hd xs])
    in
        loop(xs, [])
    end


fun number_in_months_challenge(dates: (int*int*int) list, months: int list) = 
    number_in_months(dates, remove_duplicates(months))

fun dates_in_months_challenge(dates: (int*int*int) list, months: int list) = 
    dates_in_months(dates, remove_duplicates(months))

fun is_leap_year(year: int) =
    if (year mod 400 = 0) 
    then true
    else 
        if (year mod 4 = 0) andalso (year mod 100 <> 0) 
        then true
        else false

fun reasonable_date(date: int*int*int) = 
    if (#1 date < 1) 
    then false 
    else 
        if (#2 date < 1 orelse #2 date > 12) 
        then false
        else 
            let 
                val nums = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
                
                fun day_in_month(nums: int list, month, count) = 
                    if(count = month)
                    then hd nums
                    else day_in_month(tl nums, month, count + 1)
                
                val current_day = #3 date
                val month = #2 date
                val max_num_days = day_in_month(nums, month, 1)
            in
                if (is_leap_year(#1 date) andalso (month = 2)) 
                then current_day >= 1 andalso current_day <= 29
                else current_day >= 1 andalso current_day <= max_num_days
            end
