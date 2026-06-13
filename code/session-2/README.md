## Digital Identity Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IdentitasDigital {
    // Constant: Nilai yang tidak pernah berubah
    string public constant NEGARA = "Indonesia";

    struct KTP {
        string nama;
        uint256 umur;
        bool aktif;
    }

    // Mapping: Database sederhana (Alamat Wallet => Data KTP)
    mapping(address => KTP) public daftarKTP;

    // Constructor: Menentukan admin pertama kali
    address public immutable ADMIN;

    constructor() {
        ADMIN = msg.sender;
    }

    // Fungsi untuk mendaftarkan diri sendiri
    function daftar(string memory _nama, uint256 _umur) public {
        daftarKTP[msg.sender] = KTP(_nama, _umur, true);
    }

    // Named Return: Cara bersih mengambil data
    function ambilData(address _user) public view returns (string memory nama, uint256 umur) {
  
        KTP memory data = daftarKTP[_user];
        nama = data.nama;
        umur = data.umur;
    }
}
```


## Donation Box

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KotakAmal {
    address public immutable OWNER;
    
    // Event: Agar frontend tahu ada donasi masuk
    event DonasiDiterima(address pengirim, uint256 jumlah);

    modifier onlyOwner() {
        require(msg.sender == OWNER, "Hanya pemilik yang bisa tarik dana");
        _;
    }

    constructor() {
        OWNER = msg.sender;
    }

    // Fungsi 'payable' agar kontrak bisa menerima koin
    function donasi() public payable {
        require(msg.value > 0, "Donasi tidak boleh nol");
        emit DonasiDiterima(msg.sender, msg.value);
    }

    // Fungsi untuk melihat saldo kotak amal saat ini
    function cekSaldo() public view returns (uint256) {
        return address(this).balance;
    }

    // Menarik semua dana ke kantong Owner
    function tarikDana() public onlyOwner {
        payable(OWNER).transfer(address(this).balance);
    }
}
```
