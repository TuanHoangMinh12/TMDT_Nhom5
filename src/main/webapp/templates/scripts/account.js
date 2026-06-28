const form = document.getElementById('form');
const email = document.getElementById('acc_email');
const fname = document.getElementById('acc_fname');
const lname = document.getElementById('acc_lname');
const phoneNumber = document.getElementById('acc_phoneNumber');

// 1. SỬA LỖI SUBMIT: Kiểm tra đúng hết mới cho bay sang Java
form.addEventListener('submit', (e) => {
    e.preventDefault(); // Tạm giữ lại để check lỗi

    if (checkInputs()) {
        // MẸO XỬ LÝ LỖI SỐ 3 (ĐỊA CHỈ):
        // Trước khi gửi đi, lấy "Chữ" của Tỉnh/Huyện/Xã đè ngược lại vào "Value" (thay vì gửi mã số 79, 760...)
        const citySelect = document.getElementById("city");
        const districtSelect = document.getElementById("district");
        const wardSelect = document.getElementById("ward");

        if (citySelect.selectedIndex > 0) citySelect.options[citySelect.selectedIndex].value = citySelect.options[citySelect.selectedIndex].text;
        if (districtSelect.selectedIndex > 0) districtSelect.options[districtSelect.selectedIndex].value = districtSelect.options[districtSelect.selectedIndex].text;
        if (wardSelect.selectedIndex > 0) wardSelect.options[wardSelect.selectedIndex].value = wardSelect.options[wardSelect.selectedIndex].text;

        form.submit(); // Thả xích cho form bay sang AccountController.doPost!
    }
});

function checkInputs() {
    let isValid = true; // Cờ theo dõi trạng thái

    const emailValue = email.value.trim();
    const fnameValue = fname.value.trim();
    const lnameValue = lname.value.trim();
    const phoneNumberValue = phoneNumber.value.trim();

    if (emailValue === '') {
        setErrorFor(email, 'Vui lòng nhập email của bạn');
        isValid = false;
    } else if (!isEmail(emailValue)) {
        setErrorFor(email, 'Email không hợp lệ');
        isValid = false;
    } else {
        setSuccessFor(email);
    }

    if (fnameValue === '') {
        setErrorFor(fname, 'Vui lòng nhập họ của bạn');
        isValid = false;
    } else {
        setSuccessFor(fname);
    }

    if (lnameValue === '') {
        setErrorFor(lname, 'Vui lòng nhập tên của bạn');
        isValid = false;
    } else {
        setSuccessFor(lname);
    }

    if (phoneNumberValue === '') {
        setErrorFor(phoneNumber, 'Vui lòng nhập số điện thoại của bạn');
        isValid = false;
    } else if (!isPhoneNumber(phoneNumberValue)) {
        setErrorFor(phoneNumber, 'Số điện thoại không hợp lệ');
        isValid = false;
    } else {
        setSuccessFor(phoneNumber);
    }

    return isValid; // Trả về true nếu tất cả các ô đều xanh mượt
}

function setErrorFor(input, message) {
    const formControl = input.parentElement;
    const small = formControl.querySelector('small');
    small.innerText = message;
    formControl.className = 'input error';
}

function setSuccessFor(input) {
    const formControl = input.parentElement;
    formControl.className = 'input success';
}

function isEmail(email) {
    return /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email);
}

function isPhoneNumber(phoneNumber) {
    return /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/.test(phoneNumber);
}


// ================= XỬ LÝ API ĐỊA GIỚI HÀNH CHÍNH VN =================
var citis = document.getElementById("city");
var districts = document.getElementById("district");
var wards = document.getElementById("ward");

var Parameter = {
    url: "https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json",
    method: "GET",
    responseType: "application/json",
};

var promise = axios(Parameter);
promise.then(function (result) {
    renderCity(result.data);
});

function renderCity(data) {
    for (const x of data) {
        citis.options[citis.options.length] = new Option(x.Name, x.Id);
    }

    citis.onchange = function () {
        districts.length = 1; // Sửa lỗi gõ thiếu chữ s
        wards.length = 1;     // Sửa lỗi gõ thiếu chữ s

        if (this.value != "") {
            const result = data.filter(n => n.Id === this.value);
            for (const k of result[0].Districts) {
                districts.options[districts.options.length] = new Option(k.Name, k.Id);
            }
        }
    };

    districts.onchange = function () { // Sửa lỗi gõ thiếu chữ s
        wards.length = 1;              // Sửa lỗi gõ thiếu chữ s

        const dataCity = data.filter((n) => n.Id === citis.value);
        if (this.value != "") {
            const dataWards = dataCity[0].Districts.filter(n => n.Id === this.value)[0].Wards;
            for (const w of dataWards) {
                wards.options[wards.options.length] = new Option(w.Name, w.Id);
            }
        }
    };
}