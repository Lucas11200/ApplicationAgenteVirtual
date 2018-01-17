using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ApplicationAgenteVirtual
{
    public class Historico
    {
        public string Usuario { get; set; }

        public string DataCriacao { get; set; }

        public int Grupo { get; set; }

        public string TipoFiltro { get; set; }

        public string Operador { get; set; }

        public string Valor { get; set; }

        public bool ExclusivoRobo { get; set; }
    }
}