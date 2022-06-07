using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLy_QuanCaffe_02_.DTO
{
    public class Category
    {
        public Category(int iD, string name)
        {
            this.ID = iD;
            this.Name = name;
        }

        public Category(DataRow row)
        {
            this.ID = (int)row["iD"];
            this.Name = row["name"].ToString();
        }

        private string name;
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        private int iD;
        public int ID
        {
            get { return iD; }
            set { iD = value; }
        }
    }
}
